require 'rails_helper'

RSpec.describe Api::V1::LocNamesController, type: :controller do


  before(:each) do
    valid_params = {"id"=>"1",
                    "institution_type"=>"3",
                    "country"=>"fi",
                    "inst_realm"=>"tesjjjjt.fe",
                    "address"=>"Lauttasaarentie 3",
                    "city"=>"Helsinki",
                    "contact_name"=>"Elämäm Mestari",
                    "contact_email"=>"elämäm@mestari.fi",
                    "contact_phone"=>"050505050"}



    Institution.create!(valid_params)
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

  end


  it "can change english name" do
    #/api/v1/:apikey/set/loc_name/:location_id/lang/:lang/*name
    get :set, :apikey => Institution.find(1).apikey, :lang => "en", :location_id => 1, :name => "Englishschool", session: {}

    expect(LocName.find(1).name).to eq("Englishschool")


  end
  it "can change finnish name" do
    get :set, :apikey => Institution.find(1).apikey, :lang => "fi", :location_id => 1, :name => "Fischool", session: {}

    expect(LocName.find(2).name).to eq("Fischool")


  end
  it "has correct content"  do

    visit "/api/v1/#{Institution.find(1).apikey}/get/loc_names"
    expect(page).to have_content("{\"id\":1,\"address\":\"Ratapihantie 13\",\"city\":\"Helsinki\",\"identifier\":null,\"loc_names\":[{\"lang\":\"en\",\"name\":\"Haaga-Helia University of Applied Sciences, Päsila\"},{\"lang\":\"fi\",\"name\":\"Haaga-Helia ammattikorkeakoulu, Pasila\"}]}")

  end

end
