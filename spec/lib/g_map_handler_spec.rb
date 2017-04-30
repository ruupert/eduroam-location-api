require 'rails_helper'
require 'g_map_handler'
describe "GMapHandler" do
  before(:each) do

  end
  it "can get location data-from google maps api" do

    n = GMapHandler.new("Lauttasaarentie 10", "Helsinki")
    expect(n.to_string).to eq("Lauttasaarentie 10Helsinki24°53'19.28\"E60°9'39.33\"NFItrue")

    n = GMapHandler.new("Bondi Beach NSW 2026", "Sydney")
    expect(n.to_string).to eq("Bondi Beach Bondi BeachWaverley Council151°16'56.73\"E33°53'24.96\"SNSWtrue")

    n = GMapHandler.new("Salvador Sanfuentes", "Santiago")
    expect(n.to_string).to eq("Santiago Salvador SanfuentesSantiago70°39'52.98\"W33°26'56.84\"SSantiagotrue")

  end
  it "doesn't return any data if, not valid" do
    n = GMapHandler.new("Lauttasaarentie 10", "Sweden")
    expect(n.to_string).to eq("false")
  end

end
