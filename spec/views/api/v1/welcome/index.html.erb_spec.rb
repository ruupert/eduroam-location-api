require 'rails_helper'

RSpec.describe "welcome/index.html.erb", type: :view do
  # empty page...
  it "should have page with no content" do
    expect(request).to have_content("")
  end


end
