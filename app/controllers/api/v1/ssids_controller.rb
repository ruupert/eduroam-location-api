class Api::V1::SsidsController < Api::V1::BaseController

  def set
    temp = Orgssid.where(:institution_id => apikeyToInstitutionId(params[:apikey])).find(params[:id])


    if temp.has_attribute? (params[:key])
      # ok.. could not get how to update by param[:key] as column and params[:value] as value so switch case
      case params[:key]
        when 'name'
          temp.name = params[:value]
        when 'port_restrict'
          temp.port_restrict = params[:value]
        when 'transp_proxy'
          temp.transp_proxy = params[:value]
        when 'ipv6'
          temp.ipv6 = params[:value]
        when 'nat'
          temp.nat = params[:value]
        when 'wpa_tkip'
          temp.wpa_tkip = params[:value]
        when 'wpa_aes'
          temp.wpa_aes = params[:value]
        when 'wpa2_tkip'
          temp.wpa2_tkip = params[:value]
        when 'wpa2_aes'
          temp.wpa2_aes = params[:value]
        when 'wired'
          temp.wired = params[:value]
      end
      temp.save
    end


    render(
        json: temp.as_json
    )

  end



  def get
    render(
        json: Orgssid.where(:institution_id => apikeyToInstitutionId(params[:apikey])).select(:id, :name, :port_restrict, :transp_proxy, :ipv6, :nat, :wpa_tkip, :wpa_aes, :wpa2_tkip, :wpa2_aes, :wired).as_json

    )
  end

    def get_boolean(value)
      if value.eql? "true"
        true
      else
        false
      end
    end


    def get_institution_id
      return apikeyToInstitutionId(params[:apikey])
    end

    def entry_params
      params.require(:apikey).permit(:id, :key, :value)

    end

end

