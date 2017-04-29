require 'rails_helper'

RSpec.describe Api::V1::EntriesController, type: :controller do
  before(:each) do

        Institution.create!(
            :country => "Country",
            :institution_type => 2,
            :inst_realm => "stadi.fi",
            :address => "Address",
            :city => "City",
            orgnames_attributes: [:lang => "en", :name => "TestName"],
            orgpolicies_attributes: [:lang => "en", :url => "http://testurl.en/policy"],
            orginfos_attributes: [:lang => "en", :url => "http://testurl.en/info"],
            :contact_name => "Contact Name",
            :contact_email => "Contact Email",
            :contact_phone => "Contact Phone"
        )

    Location.create!(
        :id => 1,
        :address => "jee",
        :city => "joo",
        :country => "FI",
        :longitude => "24° 56' 29.01\" E",
        :latitude => "60° 10' 3.55\" N",
        :identifier => "B",
        :institution_id => "1"
    )
    Location.create!(
        :id => 2,
        :address => "jee",
        :city => "joo",
        :country => "FI",
        :longitude => "24° 56' 29.01\" E",
        :latitude => "60° 10' 3.55\" N",
        :identifier => nil,
        :institution_id => "1"
    )
    @apikey = Institution.find(1).apikey
  end

  describe "GET #set" do
    before(:each) do
      # /api/v1/:apikey/set/:address/:identifier/:city/:ap(.:format)
      visit "/api/v1/#{@apikey}/set/location/jee/B/joo/5"

      #  "/api/v1/#{@apikey}/set/location/jee/B/joo/5"

    end
    it "returns http success" do
      visit "/api/v1/#{@apikey}/get/locations"
      puts response.body  # FFS piece of shit. nothing? 
    end
  end

  describe "GET #get" do
    before(:each) do

    end
    it "returns http success" do
      true
    end
  end
end
