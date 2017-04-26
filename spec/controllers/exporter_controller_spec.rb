require 'rails_helper'
include SimpleAuthHelper
RSpec.describe ExporterController, type: :controller do

  describe "GET #institutions" do
    describe "unauthorized" do
      before (:each) do
        basic_auth('admin','foo')
      end
      it "requires an http_autorization_token" do
        ## Implement me.
      end

    end
    describe "authorized"  do
      before(:each) do
        expect(controller).to receive(:authenticate)
      end

      it "returns http success" do

        get :institutions
        expect(response).to have_http_status(:success)
      end
    end
  end

#  describe "GET #locations" do
#    it "returns http success" do
#      get :locations
#      expect(response).to have_http_status(:success)
#    end
#  end

end
