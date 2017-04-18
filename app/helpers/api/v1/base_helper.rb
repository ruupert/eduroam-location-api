module Api::V1::BaseHelper
  def has_ssid?(institution_id)
    return !Orgssid.where(institution_id: institution_id).empty?
  end
  def valid_location?(address,identifier,city,institution_id)
    return !Location.where(address: address,identifier: identifier, city: city, institution_id: institution_id).empty?
  end

  def valid_ssid?(institution_id, ssid)
    if Orgssid.where(:id => ssid, :institution_id => institution_id).count.eql?(0)
      return false
    else
      return true
    end
  end

end