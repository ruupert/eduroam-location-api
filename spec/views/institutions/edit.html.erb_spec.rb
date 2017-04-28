require 'rails_helper'

RSpec.describe "institutions/edit", type: :view do
  before(:each) do
    @institution_types = {'IdP&SP' => 3, 'SP' => 2}

    @institution = assign(:institution, Institution.create!(
        :id => 1,
        :country => "fi",
        :institution_type => 2,
        :inst_realm => "MyString",
        :address => "MyString",
        :city => "MyString",
        :contact_name => "MyString",
        :contact_email => "MyString",
        :contact_phone => "MyString"
    ))
    @orgnames = assign(:orgname, Orgname.create!(
        :id => 1,
        :name => "myname",
        :lang => "en",
        :institution_id => 1
    ))
  end

  it "renders the edit institution form" do
    render

    assert_select "form[action=?][method=?]", institution_path(@institution), "post" do
# country not selectable
#      assert_select "input#institution_country[name=?]", "institution[country]"
# not editable
     # assert_select "input#institution_institution_type[name=?]", "institution[institution_type]"

      assert_select "input#institution_inst_realm[name=?]", "institution[inst_realm]"

      assert_select "input#institution_address[name=?]", "institution[address]"

      assert_select "input#institution_city[name=?]", "institution[city]"

      assert_select "input#institution_contact_name[name=?]", "institution[contact_name]"

      assert_select "input#institution_contact_email[name=?]", "institution[contact_email]"

      assert_select "input#institution_contact_phone[name=?]", "institution[contact_phone]"
    end
  end
end
