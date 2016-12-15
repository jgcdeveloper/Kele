require 'httparty'

class Kele

  attr_reader :response, :auth_token

  include HTTParty

  def initialize(email,password, base_url = 'https://www.bloc.io/api/v1')

    self.class.base_uri base_url

    options = {
      body: {
        email: email,
        password: password
      }
    }

    post = self.class.post('/sessions', options)
    @response = post.code
    @auth_token = post["auth_token"]

  end


end
