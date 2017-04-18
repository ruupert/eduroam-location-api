require 'rails_helper'

RSpec.describe ExporterController, type: :controller do

  describe "GET #institutions" do
    it "returns http success" do
      get :institutions
      expect(response).to have_http_status(:success)
    end
  end

#  describe "GET #locations" do
#    it "returns http success" do
#      get :locations
#      expect(response).to have_http_status(:success)
#    end
#  end

end
