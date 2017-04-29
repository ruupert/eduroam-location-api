require 'rails_helper'

RSpec.describe "institutions/index", type: :view do
  before(:each) do
    assign(:institutions, [
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
      ),
      Institution.create!(
        :country => "Country",
        :institution_type => 3,
        :inst_realm => "laru.fi",
        :address => "Address",
        :city => "City",
        orgnames_attributes: [:lang => "en", :name => "TestName"],
        orgpolicies_attributes: [:lang => "en", :url => "http://testurl.en/policy"],
        orginfos_attributes: [:lang => "en", :url => "http://testurl.en/info"],
        :contact_name => "Contact Name",
        :contact_email => "Contact Email",
        :contact_phone => "Contact Phone"
      )

    ])

    assign(:locations, [Location.create!(
        :address => "jee",
        :city => "joo",
        :country => "FI",
        :longitude => "24° 56' 29.01\" E",
        :latitude => "60° 10' 3.55\" N",
        :identifier => "B")])

  end

  it "renders a list of institutions" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 1
    assert_select "tr>td", :text => "stadi.fi".to_s, :count => 1
    assert_select "tr>td", :text => "laru.fi".to_s, :count => 1
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Contact Name".to_s, :count => 2
    assert_select "tr>td", :text => "Contact Email".to_s, :count => 2
    assert_select "tr>td", :text => "Contact Phone".to_s, :count => 2
  end
end
