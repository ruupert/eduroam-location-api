class Api::V1::EntriesController < Api::V1::BaseController
  #before_action entry_params
  include Api::V1::EntriesHelper

  def set

    if params[:ssid] == nil
      nssid_id = Orgssid.where(institution_id: get_institution_id).first.id
    else
      nssid_id = params[:ssid]
    end


    valid_existing_location = valid_location?(params[:address], params[:identifier], params[:city], get_institution_id)
    valid_ssid = valid_ssid?(get_institution_id, nssid_id)

    if valid_ssid

      if !valid_existing_location
        #create location
        nloc_id = Location.create_location(get_institution_id, params[:address], params[:identifier], params[:city])

      else
        #get location_id
        nloc_id = Location.get_location_id(get_institution_id, params[:address], params[:identifier], params[:city])
      end
      #create new entry
      Entry.create_entry(get_institution_id, nloc_id, nssid_id, params[:ap])
    else
      params[:error] = "Invalid SSID"
    end


    msg = {:valid_location => valid_existing_location, :valid_ssid => valid_ssid}
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