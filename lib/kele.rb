require 'httparty'

class Kele

  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email,password)
    options = {
      body: {
        "email": "#{email}",
        "password": "#{password}"
      }
    }

    @auth_token = self.class.post('/sessions', options).first.last
  end

  def user_token
    @auth_token
  end

end
