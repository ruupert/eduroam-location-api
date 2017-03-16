require 'rails_helper'

RSpec.describe "institutions/index", type: :view do
  before(:each) do
    assign(:institutions, [
      Institution.create!(
        :country => "Country",
        :institution_type => 2,
        :inst_realm => "Inst Realm",
        :address => "Address",
        :city => "City",
        :contact_name => "Contact Name",
        :contact_email => "Contact Email",
        :contact_phone => "Contact Phone"
      ),
      Institution.create!(
        :country => "Country",
        :institution_type => 2,
        :inst_realm => "Inst Realm",
        :address => "Address",
        :city => "City",
        :contact_name => "Contact Name",
        :contact_email => "Contact Email",
        :contact_phone => "Contact Phone"
      )
    ])
  end

  it "renders a list of institutions" do
    render
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Inst Realm".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Contact Name".to_s, :count => 2
    assert_select "tr>td", :text => "Contact Email".to_s, :count => 2
    assert_select "tr>td", :text => "Contact Phone".to_s, :count => 2
  end
end
