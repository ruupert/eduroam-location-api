class Institution < ActiveRecord::Base
  before_create :new_apikey, :default_country

  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless Institution.exists?(apikey: token)
    end
  end

  private
  def new_apikey
    self.apikey = self.generate_api_key

  end

  def default_country
    raise "NRO_COUNTRY env variable not defined!" if ENV['NRO_COUNTRY'].nil?
    raise "NRO_COUNTRY env variable is invalid!" if ISO3166::Country.find_all_by_alpha2(ENV['NRO_COUNTRY']).nil?
    self.country = ENV['NRO_COUNTRY']
  end

end
