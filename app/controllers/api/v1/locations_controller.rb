class Api::V1::LocationsController < Api::V1::BaseController

  def set
    temp = Location.where(:institution_id => apikeyToInstitutionId(params[:apikey])).find(params[:id])


    if temp.has_attribute? (params[:key])
      # ok.. could not get how to update by param[:key] as column and params[:value] as value so switch case
      case params[:key]
        when 'identifier'
          temp.address = params[:value]
      end
      temp.save
    end


    render(
        json: temp.as_json
    )

  end


  def get
    render(
        json: Location.where(:institution_id => apikeyToInstitutionId(params[:apikey])).select(:id, :address, :identifier, :city, :country)

    )
  end

  def get_boolean(value)
    if value == "true" or "1"
      !!value
    else
      !value
    end
  end


  def get_institution_id
    return apikeyToInstitutionId(params[:apikey])
  end

  def entry_params
    params.require(:apikey).permit(:id, :key, :value)

  end


end