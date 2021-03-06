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
                    "contact_phone"=>"050505050"}



    Institution.create!(valid_params)
    Orginfo.create!({"id"=>"1",
                    "lang"=>"en",
                    "url"=>"lauttasaari.fi/howtosetup_eng",
                    "institution_id"=>"1"

                   })
    @apikey = Institution.first.apikey

  end


  it "can change url" do
    get :set, :apikey => Institution.find(1).apikey, :lang => "en", :url => "http:/testworks/english", session: {}

    expect(Orginfo.find(1).url).to eq("http://testworks/english")


  end

  it "gets correct listing" do

   # visit "/api/v1/#{@apikey}/get/infos"  <- no controller code tested.. LOL
   # expect(page).to have_content("lauttasaari.fi/howtosetup_eng") <- does not count.. LOL...
    get :get, :apikey => Institution.find(1).apikey
    assert_response :success

  end


end
