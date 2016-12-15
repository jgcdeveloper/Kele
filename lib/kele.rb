require 'httparty'

class Kele

  attr_reader :user_token

  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email,password)

    options = {
      body: {
        email: email,
        password: password
      }
    }

    @user_token = self.class.post('/sessions', options).first.last

  end


end
