require 'rails_helper'

RSpec.describe Api::V1::OrginfosController, type: :controller do


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


  it "can change name" do
    url = "http://testworks/english"
    visit "/api/v1/#{@apikey}/set/info/lang/en/#{url.scrub}"
    expect(Orginfo.find(1).url).to eq("http://testworks/english")


  end

end
