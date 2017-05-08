require 'rails_helper'
include SimpleAuthHelper
RSpec.describe "Institutions", type: :request do
  describe "GET /institutions" do
    describe "unauthenticated" do
      it "should have http status 401" do

        get institutions_path
        expect(response).to have_http_status(401)
      end

    end

    describe "authenticated" do
      it "should have http status 200" do
        get_with_auth '/institutions', ENV['EDUROAM_API_ADMIN_USERNAME'], ENV['EDUROAM_API_ADMIN_PW']
        expect(response).to have_http_status(200)
      end

    end
  end
end
