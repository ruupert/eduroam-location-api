require 'rails_helper'
describe "welcome/index.html.erb" do
  it "displays APIv1" do
    visit root_path
    expect(page).to have_content("Eduroam Location API")
  end
end
