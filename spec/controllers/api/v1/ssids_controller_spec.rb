require 'rails_helper'

RSpec.describe Api::V1::SsidsController, type: :controller do
  before(:each) do
    valid_params = {"id"=>"1",
                    "institution_type"=>"3",
                    "country"=>"fi",
                    "inst_realm"=>"tesjjjjt.fe",
                    "address"=>"Lauttasaarentie 3",
                    "city"=>"Helsinki",
                    "contact_name"=>"Elämäm Mestari",
                    "contact_email"=>"elämäm@mestari.fi",
                    "contact_phone"=>"050505050",
                    "orgnames_attributes"=>[{"lang"=>"en", "name"=>"TestUni"}],
                    "orgpolicies_attributes"=>[{"lang"=>"en", "url"=>"lauttasaari.fi/rules_eng"}],
                    "orginfos_attributes"=>[{"lang"=>"en", "url"=>"lauttasaari.fi/howtosetup_eng"}]
    }
    Institution.create(valid_params)
    @apikey = Institution.first.apikey

  end
  describe "GET #set" do
    it "it sets correctly ssid" do
 
    end
  end

  describe "GET #get" do
    it "it gets correct ssid count" do
      visit "/api/v1/#{@apikey}/get/ssids"
      expect(page).to have_content("{\"ssids\":[{\"id\":1,\"name\":\"eduroam\",\"port_restrict\":false,\"transp_proxy\":false,\"ipv6\":false,\"nat\":false,\"wpa_tkip\":false,\"wpa_aes\":false,\"wpa2_tkip\":false,\"wpa2_aes\":true,\"wired\":false}]}")

    end
  end

end
