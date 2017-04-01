class Orgssid < ActiveRecord::Base
  belongs_to :institution
  has_many :entries
  before_create :default_values

  private
  def default_values
    if Orgssid.find(:institution_id).nil?
      self.number = 0
      self.wpa_tkip = 0
      self.wpa2_tkip = 0
      self.wpa2_aes = 1
      self.wpa_aes = 0
      self.ipv6 = 0
      self.nat = 0
      self.port_restrict = 0
      self.transp_proxy = 0
    end
  end

end
