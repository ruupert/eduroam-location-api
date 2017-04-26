require 'rails_helper'

RSpec.describe "welcome/doc.html.erb", type: :view do
  it "displays APIv1" do
    visit api_v1_doc_path
    expect(page).to have_content("APIv1")
    end
end
