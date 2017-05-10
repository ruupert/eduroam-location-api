require 'rails_helper'

RSpec.describe Api::V1::LocationsController, type: :controller do
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
                        "identifier"=>"C"
                    }

    )


    @apikey = Institution.first.apikey
  end
  describe "GET #set" do
    it "it sets correctly a location entry" do
      get :get, :apikey => Institution.find(1).apikey, :address => "Ratapihantie 13", :identifier => "C", :city => "Helsinki", :ssid => "1", :ap => "70",session: {}

      expect(Location.all.count).to eq(1)
    end
    it "it sets correctly two locations entries in succession" do
      get :get, :apikey => Institution.find(1).apikey, :address => "Ratapihantie 13", :identifier => "C", :city => "Helsinki", :ap => "5",session: {}
      get :get, :apikey => Institution.find(1).apikey, :address => "Ratapihantie 13", :identifier => "C", :city => "Helsinki", :ap => "70",session: {}
      expect(Orgssid.all.count).to eq(1)
      expect(Location.all.count).to eq(1)
    end

    it "it gets correctly with one location" do
      get :get, :apikey => Institution.find(1).apikey, :address => "Ratapihantie 13", :identifier => "B", :city => "Helsinki", :ssid => "1", :ap => "70",session: {}
      expect(Location.find(1).identifier).to eq("C")
    end
    it "checks boolean ok" do
      expect(controller.get_boolean("true")).to eq(true)
      expect(controller.get_boolean("1")).to eq(true)
      expect(controller.get_boolean("treu")).to eq(false)
      expect(controller.get_boolean("tffsa")).to eq(false)
    end
  end



describe "Visit #set" do
    it "it sets correctly location" do
      visit "/api/v1/#{@apikey}/set/location/Ratapihantie%2013/0/Helsinki/5/1"

      expect(Entry.find(1).ap_count).to eq(5)
    end
  end


  describe "Visit #get" do
    it "it gets correct location" do
      visit "/api/v1/#{@apikey}/get/locations"
      expect(page).to have_content("{\"locations\":[{\"id\":1,\"address\":\"Ratapihantie 13\",\"city\":\"Helsinki\",\"country\":\"fi\",\"identifier\":\"C\"}]}")


    end
  end

end
