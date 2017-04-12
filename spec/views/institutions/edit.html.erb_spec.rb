require 'rails_helper'

RSpec.describe "institutions/edit", type: :view do
  before(:each) do
    @institution = assign(:institution, Institution.create!(
      :country => "MyString",
      :institution_type => 1,
      :inst_realm => "MyString",
      :address => "MyString",
      :city => "MyString",
      :contact_name => "MyString",
      :contact_email => "MyString",
      :contact_phone => "MyString"
    ))
  end

  it "renders the edit institution form" do
    render

    assert_select "form[action=?][method=?]", institution_path(@institution), "post" do

      assert_select "input#institution_country[name=?]", "institution[country]"

      assert_select "input#institution_institution_type[name=?]", "institution[institution_type]"

      assert_select "input#institution_inst_realm[name=?]", "institution[inst_realm]"

      assert_select "input#institution_address[name=?]", "institution[address]"

      assert_select "input#institution_city[name=?]", "institution[city]"

      assert_select "input#institution_contact_name[name=?]", "institution[contact_name]"

      assert_select "input#institution_contact_email[name=?]", "institution[contact_email]"

      assert_select "input#institution_contact_phone[name=?]", "institution[contact_phone]"
    end
  end
end
