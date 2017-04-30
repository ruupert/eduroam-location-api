require 'rails_helper'
include SimpleAuthHelper
RSpec.describe ExporterController, type: :controller do

  describe "GET #institutions" do
    describe "unauthorized" do
      before (:each) do
        basic_auth('admin','foo')
      end
      it "requires an http_autorization_token" do
        visit exporter_institutions_url
        expect(page).to have_content("HTTP Basic: Access denied.")
      end

    end
    describe "authorized"  do
      render_views
      before(:each) do
        expect(controller).to receive(:authenticate)
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

      it "returns http success" do

        get :institutions
        expect(response).to have_http_status(:success)
      end
      it "returns a valid xml" do


        get :institutions

        expect(response.body).to have_content("Helsinki")





      end


    end
  end

end
