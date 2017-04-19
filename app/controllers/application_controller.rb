class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['EDUROAM_API_ADMIN_USERNAME'] and password == ENV['EDUROAM_API_ADMIN_PW']
    end
  end

end
