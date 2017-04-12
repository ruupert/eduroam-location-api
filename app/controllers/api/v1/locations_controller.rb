class Api::V1::LocationsController < Api::V1::BaseController
  def list

    render(
        json: Location.where(:institution_id => apikeyToInstitutionId(params[:apikey])).as_json

    )
  end


end