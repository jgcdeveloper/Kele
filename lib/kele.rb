require 'httparty'
require 'json'

class Kele

  attr_reader :http_response, :auth_token, :current_user,
              :current_user_mentor_id, :current_user_mentor_availability

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

  def get_me

    raise Kele::InvalidAuthTokenError if @auth_token == nil

    #Using our authorization token to retrieve the current user
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })

    #Taking the API response and converting the body to a ruby hash
    @current_user = JSON.parse(response.body)

    #Can use this method to set any attributes we require automatically once current_user has been set
    set_my_attributes

    #I use return here so that I return nil instead of the last evaluated statement in the last method of set_my_attributes
    return

  end


  def get_mentor_availability(mentor_id = @current_user_mentor_id)

    raise Kele::InvalidMentorID if mentor_id == nil

    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: {"authorization" => @auth_token })
    @current_user_mentor_availability = JSON.parse(response.body)

  end

  private

  #set_my_attributs is a private call to list other methods for setting current_user attributes
  def set_my_attributes
    get_my_mentor_id
  end

  #called by set_my_attributes, this will set the current_user_mentor_id attribute
  def get_my_mentor_id
    @current_user_mentor_id = current_user["current_enrollment"]["mentor_id"]
  end


end

class Kele::InvalidAuthTokenError < StandardError; end
class Kele::InvalidMentorID < StandardError; end
