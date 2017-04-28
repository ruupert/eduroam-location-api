require 'rails_helper'

=begin
RSpec.describe "institutions/show", type: :view do
  before(:each) do
    @institution = assign(:institution, Institution.create!(
      :country => "Country",
      :institution_type => 3,
      :inst_realm => "Inst Realm",
      :address => "Address",
      :city => "City",
      :contact_name => "Contact Name",
      :contact_email => "Contact Email",
      :contact_phone => "Contact Phone"
    ))
    @orgname = assign(:orgname, Orgname.create!(
        :id => 1,
        :name => "myname",
        :lang => "en",
        :institution_id => 1
    ))
    @orgpolicy = assign(:orgpolicy, Orgpolicy.create!(
        :id => 1,
        :url => "myname",
        :lang => "en",
        :institution_id => 1
    ))
    @orginfo = assign(:orginfo, Orginfo.create!(
        :id => 1,
        :url => "myname",
        :lang => "en",
        :institution_id => 1
    ))

  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Inst Realm/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Contact Name/)
    expect(rendered).to match(/Contact Email/)
    expect(rendered).to match(/Contact Phone/)
  end
end
=end
