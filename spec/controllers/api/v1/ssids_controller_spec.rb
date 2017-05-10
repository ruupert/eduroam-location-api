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
      expect(page).to have_content("{\"ssids\":[{\"id\":1,\"name\":\"eduroam\",\"port_restrict\":false,\"transp_proxy\":false,\"ipv6\":false,\"nat\":false,\"wpa_tkip\":false,\"wpa_aes\":false,\"wpa2_tkip\":false,\"wpa2_aes\":true,\"wired\":false},{\"id\":2,\"name\":\"eduroam\",\"port_restrict\":false,\"transp_proxy\":false,\"ipv6\":false,\"nat\":false,\"wpa_tkip\":false,\"wpa_aes\":false,\"wpa2_tkip\":false,\"wpa2_aes\":true,\"wired\":false}]}")

    end
  end

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
    Location.create({
                        "id"=>1,
                        "address"=>"Ratapihantie 13",
                        "city"=>"Helsinki",
                        "country"=>"fi",
                        "longitude"=>"24°56'02.00\"E",
                        "latitude"=>"60°12'04.00\"N",
                        "created_at"=>"Tue, 18 Apr 2017 04:54:11 UTC +00:00",
                        "updated_at"=>"Tue, 18 Apr 2017 04:54:11 UTC +00:00",
                        "institution_id"=>"1",
                        "identifier"=>nil
                    }

    )
    LocName.create({
                       "id"=>"1",
                       "lang"=>"en",
                       "name"=>"Haaga-Helia University of Applied Sciences, Päsila",
                       "created_at"=>"Tue, 18 Apr 2017 04:54:11 UTC +00:00",
                       "updated_at"=>"Tue, 18 Apr 2017 04:54:11 UTC +00:00",
                       "location_id"=>"1"
                   })
    LocName.create({
                       "id"=>"2",
                       "lang"=>"fi",
                       "name"=>"Haaga-Helia ammattikorkeakoulu, Pasila",
                       "created_at"=>"Tue, 18 Apr 2017 04:54:11 UTC +00:00",
                       "updated_at"=>"Tue, 18 Apr 2017 04:54:11 UTC +00:00",
                       "location_id"=>"1"
                   })
    Orgssid.create_default(1)
    Entry.create({
                     "id"=>"1",
                     "institution_id"=>"1",
                     "location_id"=>"1",
                     "ap_count"=>"34",
                     "orgssid_id"=>"1"
                 })
    @apikey = Institution.find(1).apikey

  end




  it "gets the right location_id" do

    expect(Location.get_location_id(1,"Ratapihantie 13",nil, "Helsinki")).to eq(1)

  end
  it "can add a google maps api verifiable location" do

    Institution.create(address: "Lauttasaarentie 10B",
                       inst_realm: "laru.fi",
                       institution_type: 2,
                       contact_email: "helpdesk@laru.foo",
                       contact_name: "welp",
                       contact_phone: "999",
                       id: 5)
    Location.create_location(5,"Lauttasaarentie 10", "B","Helsinki")
    expect(Location.get_location_id(5,"Lauttasaarentie 10","B", "Helsinki")).to eq(2)
  end

  it "can change name" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "name", :value => "testname", session: {}
    expect(Orgssid.find(1).name).to eq("testname")


  end
  it "can change port_restrict" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "port_restrict", :value => "true", session: {}
    expect(Orgssid.find(1).port_restrict).to eq(true)

  end
  it "can change transp_proxy" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "transp_proxy", :value => "true", session: {}
    expect(Orgssid.find(1).transp_proxy).to eq(true)

  end
  it "can change ipv6" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "ipv6", :value => "true", session: {}
    expect(Orgssid.find(1).ipv6).to eq(true)
  end
  it "can change nat" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "nat", :value => "true", session: {}
    expect(Orgssid.find(1).nat).to eq(true)
  end
  it "can change wpa_tkip" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "wpa_tkip", :value => "true", session: {}
    expect(Orgssid.find(1).wpa_tkip).to eq(true)
  end
  it "can change wpa_aes" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "wpa_aes", :value => "true", session: {}
    expect(Orgssid.find(1).wpa_aes).to eq(true)
  end
  it "can change wpa2_tkip" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "wpa2_tkip", :value => "true", session: {}
    expect(Orgssid.find(1).wpa2_tkip).to eq(true)
  end
  it "can change wpa2_aes" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "wpa2_aes", :value => "false", session: {}
    expect(Orgssid.find(1).wpa2_aes).to eq(false)
  end
  it "can change wired" do
    get :set, :apikey => Institution.find(1).apikey, :id => "1", :key => "wired", :value => "true", session: {}
    expect(Orgssid.find(1).wired).to eq(true)
  end


end
