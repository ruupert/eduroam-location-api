class Orgssid < ActiveRecord::Base
  belongs_to :institution
  has_many :entries

  #before_update :next_num

  def self.getCount ins_id
    self.where(:institution_id => ins_id).count
  end
  def self.getDefaultSsid ins_id
    self.where(:institution_id => ins_id).first
  end
  def enc_levels
    res = ""
    if self.wpa_aes
      res += "WPA/AES, "
    end
    if self.wpa_tkip
      res += "WPA/TKIP, "
    end
    if self.wpa2_aes
      res += "WPA2/AES, "
    end
    if self.wpa2_tkip
      res += "WPA2/TKIP, "
    end
    return res.chomp(", ")
  end

  def self.create_default(institution_id)
    nssid = Orgssid.new
    nssid.institution_id = institution_id
    nssid.wpa_aes = false
    nssid.wpa_tkip = false
    nssid.wpa2_tkip = false
    nssid.wpa2_aes = true
    nssid.name = 'eduroam'
    nssid.wired = false
    nssid.ipv6 = false
    nssid.nat = false
    nssid.transp_proxy = false
    nssid.port_restrict = false
    nssid.save
    return nssid.id
  end

  #private
  def next_num
    self.number = Orgssid.where(institution_id: self.institution_id).maximum(:number).to_i + 1
  end


end

