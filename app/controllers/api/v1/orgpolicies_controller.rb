class Api::V1::OrgpoliciesController < Api::V1::BaseController
  def get
    render(
        json: Orgpolicy.where(:institution_id => apikeyToInstitutionId(params[:apikey])).select(:id, :lang, :url).as_json


    )

  end

  def set
    temp = Orgpolicy.where(:institution_id => apikeyToInstitutionId(params[:apikey]), :lang => params[:lang]).first
    temp.url = params[:url]
    temp.save
    render(
        json: temp.as_json
    )

  end

  private
  def get_institution_id
    return apikeyToInstitutionId(params[:apikey])
  end

  def entry_params
    params.require(:apikey).permit(:lang, :url)

  end

end
