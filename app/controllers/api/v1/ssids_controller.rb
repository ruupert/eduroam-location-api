class Api::V1::SsidsController < Api::V1::BaseController
  def set

  end
  def list
    render(
        json: Orgssid.where(:institution_id => apikeyToInstitutionId(params[:apikey])).select(:id,:name,:port_restrict,:transp_proxy,:ipv6,:nat,:wpa_tkip,:wpa_aes,:wpa2_tkip,:wpa2_aes,:wired).as_json

    )


  end
  def show
    render(

        json: ActiveModel::ArraySerializer.new(Orgssid.find_by_institution_id(params[:id]).as_json).to_json
    )
  end
end