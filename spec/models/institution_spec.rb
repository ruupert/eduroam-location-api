require 'rails_helper'

RSpec.describe Institution, type: :model do
  it "saved with correct values" do
    ins = Institution.new address: "Lauttasaarentie 10B",
                          inst_realm: "laru.fi",
                          institution_type: 2,
                          contact_email: "helpdesk@laru.foo",
                          contact_name: "welp",
                          contact_phone: "999",
                          id: 1

    expect(ins.address).to eq("Lauttasaarentie 10B")
    expect(ins.inst_realm).to eq("laru.fi")
    expect(ins.institution_type).to eq(2)
    expect(ins.contact_name).to eq("welp")
    expect(ins.contact_email).to eq("helpdesk@laru.foo")
    expect(ins.contact_phone).to eq("999")
    expect(ins.id).to eq(1)

=begin
    ins.city = "Helsinki"
    # ins.country is not definable since that value is set to environment variable NRO_COUNTRY
    ins.institution_type = 2
    ins.inst_realm = "laru.foo"
    ins.contact_email = "helpdesk@laru.foo"
    ins.contact_phone = "+358-HELPMEPLZ"
    ins.contact_name = "Welpdesk"
    ins.orgpolicies.lang = "en"
    ins.orgpolicies.url = "http://laru.foo/policy"
    ins.orginfos.lang = "en"
    ins.orginfos.url = "http://laru.foo/help"
    ins.save

=end


  end
end
