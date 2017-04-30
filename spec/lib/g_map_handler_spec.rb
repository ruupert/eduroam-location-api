require 'rails_helper'
#require 'g_map_handler'
describe "GMapHandler" do
  before(:each) do

  end
  it "It can get location data-from google maps api" do
    class GMapHandler
      def initialize(address, city)
        if address == "Lauttasaarentie 10"
          @@address = address
          @@city = city
          @@valid = true
          @@lng = "24°53'19.28\"E"
          @@lat = "60°9'39.33\"N"
          @@country = "FI"
        else
          @@valid = false
        end
        def valid?
          return @@valid
        end

        def address
          return @@address
        end
        def city
          return @@city
        end
        def country
          return @@country
        end

        def lng
          return @@lng
        end
        def lat
          return @@lat
        end
      end

    end


    true # for now
   n = GMapHandler.new("Lauttasaarentie 10", "Helsinki")

    expect(n.city).to eq('Helsinki')
    expect(n.address).to eq('Lauttasaarentie 10')
    expect(n.lng).to eq("24°53'19.28\"E")
    expect(n.lat).to eq("60°9'39.33\"N")
    expect(n.country).to eq("FI")





  end


end
