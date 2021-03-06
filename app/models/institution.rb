class Institution < ActiveRecord::Base
  has_many :orgnames
  has_many :orginfos, autosave: true
  has_many :orgpolicies, autosave: true
  has_many :orgssids, autosave: true
  has_many :entries, autosave: true
  has_many :locations, autosave: true
  accepts_nested_attributes_for :orgnames
  accepts_nested_attributes_for :orginfos
  accepts_nested_attributes_for :orgpolicies
  accepts_nested_attributes_for :orgssids
  accepts_nested_attributes_for :locations
  accepts_nested_attributes_for :entries
  # minimum length of a realm would be four letters: "a.fi". this spot could house some custom validation which checks if
  # realm exists by telneting to target radius port (or something)...
  validates :inst_realm, presence: true, length: {minimum: 4}, uniqueness: {scope: [:inst_realm], message: "Given realm already exists!"}
  validates :institution_type, presence: true, :inclusion => {:in => [2,3]}  # institution type can be either 2 or 3. type 1 is the NRO
  validates_uniqueness_of :inst_realm, :scope => [:country, :institution_type, :inst_realm ], message: "Institution already exists"

  before_create :new_apikey, :default_country
  after_create :create_default_ssid

  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless Institution.exists?(apikey: token)
    end
  end

  def primary_name
    orgnames.first.name
#    self.orgnames.first.name
  end

  def primary_info_url
    self.orginfos.first.url
  end

  def primary_policy_url
    self.orgpolicies.first.url
  end

  def create_default_ssid
     Orgssid.create_default(self.id)
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
