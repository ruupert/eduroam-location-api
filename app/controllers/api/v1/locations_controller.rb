class Api::V1::LocationsController < Api::V1::BaseController

  def get
    render(
        json: Location.where(:institution_id => apikeyToInstitutionId(params[:apikey])).select(:id, :address, :identifier, :city, :country)

    )
  end

  def get_boolean(value)
    if value == "true" or value == "1"
      return true
    else
      return false
    end
  end


  def get_institution_id
    return apikeyToInstitutionId(params[:apikey])
  end

  def entry_params
    params.require(:apikey).permit(:address, :city, :identifier, :ssid, :ap)
  end


end