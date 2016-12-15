require 'httparty'

class Kele

  attr_reader :auth_token

  include HTTParty

  def initialize(email,password, base_url = 'https://www.bloc.io/api/v1')

    self.class.base_uri base_url

    options = {
      body: {
        email: email,
        password: password
      }
    }

    response = self.class.post('/sessions', options)
    @auth_token = response["auth_token"]

  end


end
