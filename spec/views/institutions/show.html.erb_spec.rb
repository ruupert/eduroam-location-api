require 'rails_helper'

RSpec.describe "institutions/show", type: :view do
  before(:each) do
    @institution = assign(:institution, Institution.create!(
      :country => "Country",
      :institution_type => 2,
      :inst_realm => "Inst Realm",
      :address => "Address",
      :city => "City",
      :contact_name => "Contact Name",
      :contact_email => "Contact Email",
      :contact_phone => "Contact Phone"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Inst Realm/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Contact Name/)
    expect(rendered).to match(/Contact Email/)
    expect(rendered).to match(/Contact Phone/)
  end
end
