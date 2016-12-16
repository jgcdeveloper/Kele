require 'httparty'
require 'json'

class Kele

  attr_reader :http_response, :auth_token, :current_user

  include HTTParty

  #This method will execute when the class is instansiated
  def initialize(email,password, base_url = 'https://www.bloc.io/api/v1')

    self.class.base_uri base_url

    options = {
      body: {
        email: email,
        password: password
      }
    }

    post = self.class.post('/sessions', options)
    @http_response = post.code
    @auth_token = post["auth_token"]

  end

  #This method will retrieve the user information from the API, strip the headers,
  #and convert into a ruby hash form. It will then store that into @current_user
  #and also return it from the method.

  def get_me

    if (@auth_token)
      puts "Setting user data into @current_user"

      #Using our authorization token to retrieve the current user
      response = self.class.get('/users/me', headers: { "authorization" => @auth_token })

      #Taking the API response and converting the body to a ruby hash
      @current_user = JSON.parse(response.body)

    else

      puts "Cannot retrieve current user without a valid authorization token"

      #With an invalid token, @current_user will be set to nil
      @current_user = nil

    end

  end

end
