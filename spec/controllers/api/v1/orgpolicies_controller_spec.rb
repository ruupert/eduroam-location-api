require 'rails_helper'

RSpec.describe Api::V1::OrgpoliciesController, type: :controller do


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
    Orgpolicy.create!({"id"=>"1",
                    "lang"=>"en",
                    "url"=>"lauttasaari.fi/howtosetup_eng",
                    "institution_id"=>"1"

                   })
    @apikey = Institution.first.apikey

  end


  it "can change url" do
    get :set, :apikey => Institution.find(1).apikey, :lang => "en", :url => "http:/testworks/english", session: {}

    expect(Orgpolicy.find(1).url).to eq("http://testworks/english")


  end
  it "gets correct listing" do
    visit "/api/v1/#{@apikey}/get/policies"
    expect(page).to have_content("lauttasaari.fi/howtosetup_eng")

  end

end
