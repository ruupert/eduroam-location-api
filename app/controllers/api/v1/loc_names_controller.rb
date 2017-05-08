class Api::V1::LocNamesController < Api::V1::BaseController
  def get
    loc = Location.where(:institution_id => apikeyToInstitutionId(params[:apikey])).includes(:loc_names).select(:id, :address, :identifier, :city)
    render(
        json: loc.to_json(:include => { :loc_names => { :only => [:lang, :name]} })
    )

  end

  def set
    temp = Location.where(:institution_id => apikeyToInstitutionId(params[:apikey])).find(params[:location_id]).loc_names.where(lang: params[:lang]).first

    temp.name = params[:name]
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
    params.require(:apikey).permit(:location_id, :lang, :name)

  end

end
