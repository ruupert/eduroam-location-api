require 'rails_helper'

RSpec.describe Api::V1::WelcomeController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #doc" do
    it "returns http success" do
      get :doc
      expect(response).to have_http_status(:success)
    end
  end

end
