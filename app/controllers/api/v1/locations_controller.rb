class Api::V1::LocationsController < Api::V1::BaseController
  def list

    render(
        json: Location.where(:institution_id => apikeyToInstitutionId(params[:apikey])).select(:id,:address,:identifier,:city,:country)

    )
  end


end