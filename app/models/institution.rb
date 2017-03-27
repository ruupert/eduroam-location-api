class Institution < ActiveRecord::Base
  has_many :orgnames
  has_many :orginfos
  has_many :orgpolicies
  has_many :orgssids
  accepts_nested_attributes_for :orgnames
  accepts_nested_attributes_for :orginfos
  accepts_nested_attributes_for :orgpolicies
  accepts_nested_attributes_for :orgssids
  validates :inst_realm, presence: true, length: {minimum: 3}, uniqueness: {scope: [:realm], message: "Given realm already exists!"}
  before_create :new_apikey, :default_country

  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless Institution.exists?(apikey: token)
    end
  end

  def primary_name
    self.orgnames.first.name
  end

  def primary_info_url
    self.orginfos.first.url
  end

  def primary_policy_url
    self.orgpolicies.first.url
  end


  private
  def new_apikey
    self.apikey = generate_api_key()

  end

  def default_country
    raise "NRO_COUNTRY env variable not defined!" if ENV['NRO_COUNTRY'].nil?
    raise "NRO_COUNTRY env variable is invalid!" if ISO3166::Country.find_all_by_alpha2(ENV['NRO_COUNTRY']).nil?
    self.country = ENV['NRO_COUNTRY']
  end

end
