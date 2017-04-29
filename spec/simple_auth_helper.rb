module SimpleAuthHelper
  #def http_login
  #  @env ||= {}
  #  user = ENV['EDUROAM_ADMIN_USERNAME']
  #  pw = ENV['EDUROAM_ADMIN_PW']
  #  @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  #end

  def basic_auth(user, password)
    if ENV['EDUROAM_API_ADMIN_PW'].equal? password
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials user, password
    request.env['HTTP_AUTHORIZATION'] = credentials
    end

  end
  def get_with_auth(path, username, password)
    get path, {}, env_with_auth(username, password)
  end
  def visit_basic_auth(name, password)
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(name, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(name, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(name, password)
    else
      raise "I don't know how to log in!"
    end
  end
  def env
    {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
    }
  end

  def env_with_auth(username, password)
    env.merge({
                  'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
              })
  end
end