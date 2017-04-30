require 'rails_helper'

RSpec.describe Location, type: :model do
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
    end


  it "gets the right location_id" do

    expect(Location.get_location_id(1,"Ratapihantie 13",nil, "Helsinki")).to eq(1)

  end
    it "can add a google maps api verifiable location" do
      class GMapHandler
        def initialize(address, city)
          if address == "Lauttasaarentie 10"
            @@address = address
            @@city = city
            @@valid = true
            @@lng = "24°53'19.28\"E"
            @@lat = "60°9'39.33\"N"
            @@country = "FI"
          else
            @@valid = false
          end
          def valid?
            return @@valid
          end

          def address
            return @@address
          end
          def city
            return @@city
          end
          def country
            return @@country
          end

          def lng
            return @@lng
          end
          def lat
            return @@lat
          end
        end

      end
      Institution.create(address: "Lauttasaarentie 10B",
                            inst_realm: "laru.fi",
                            institution_type: 2,
                            contact_email: "helpdesk@laru.foo",
                            contact_name: "welp",
                            contact_phone: "999",
                            id: 5)
      Location.create_location(5,"Ratapihantie 13", "B","Helsinki")

      # expect(Location.get_location_id(1,"Ratapihantie 13","B", "Helsinki")).to eq(1)
    end


end
