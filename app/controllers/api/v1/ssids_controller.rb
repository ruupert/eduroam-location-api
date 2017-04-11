class Api::V1::SsidsController < Api::V1::BaseController
  def set

  end
  def list
    render(
        json: Orgssid.where(:institution_id => apikeyToInstitutionId(params[:apikey])).as_json

    )


  end
  def show
    render(

        json: ActiveModel::ArraySerializer.new(Orgssid.find_by_institution_id(params[:id]).as_json).to_json
    )
  end
end