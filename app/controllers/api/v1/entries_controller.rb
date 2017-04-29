class Api::V1::EntriesController < Api::V1::BaseController
  #before_action entry_params
  include Api::V1::EntriesHelper

  def set
    # Move this cargo culture to MODELS! 
    #
    valid_location = valid_location?(params[:address], params[:identifier], params[:city], get_institution_id)
    valid_ssid = valid_ssid?(get_institution_id, params[:ssid])
    has_ssid = has_ssid?(get_institution_id)

    unless has_ssid
      params[:error] = "No SSID"
      # create default ssid
      nssid_id = Orgssid.create_default(institution_id:get_institution_id)
    end

    if valid_ssid
      unless valid_location
        #create location
        nloc_id = Location.create_location(get_institution_id,params[:address], params[:identifier],params[:city])

      else
        #get location_id
        nloc_id = Location.get_location_id(get_institution_id, params[:address], params[:identifier],params[:city])
      end
      #create new entry
      Entry.create_entry(get_institution_id, nloc_id , nssid_id, params[:ap])
    else
      params[:error] = "Invalid SSID"
    end



    msg = {:valid_location => valid_location, :valid_ssid => valid_ssid, :has_ssid => has_ssid}
    params[:msg] = msg
    render(

        json: ActiveModel::ArraySerializer.new(params)
    )

  end

  def get

  end

  private
  def get_institution_id
    return apikeyToInstitutionId(params[:apikey])
  end

  def entry_params
    params.require(:apikey).permit(:address, :identifier, :city, :ap)

  end

end