require 'rails_helper'

RSpec.describe "exporter/institutions.html.erb", type: :view do
  it "should have some xml" do
    expect(request).to have_content("xml")
  end
end
