require 'httparty'
require 'json'
require 'kele_roadmap'
require 'kele_messaging'
require 'kele_checkpoints'

class Kele

  attr_reader :auth_token, :current_user,
              :current_user_mentor_id, :current_user_mentor_availability,
              :current_user_enrollment_id


  attr_accessor :roadmap, :checkpoint

  include HTTParty
  include Roadmap
  include Messaging
  include Checkpoints


  #This method will execute when the class is instansiated
  def initialize(email,password, base_url = 'https://www.bloc.io/api/v1')
    self.class.base_uri base_url

    options = {
      body: {
        email: email,
        password: password
      }
    }

    response = self.class.post('/sessions', options)
    raise Kele::InvalidCredentials if response.code != 200

    @auth_token = response["auth_token"]


  end

  #This method will retrieve the user information from the API, strip the headers,
  #and convert into a ruby hash form. It will then store that into @current_user

  def get_me
    #Using our authorization token to retrieve the current user
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })

    #Taking the API response and converting the body to a ruby hash
    @current_user = JSON.parse(response.body)

    #Can use this method to set any attributes we require automatically once current_user has been set
    set_my_attributes

    #I use return here so that I return nil instead of the last evaluated statement in the last method of set_my_attributes
    return @current_user
  end


  def get_mentor_availability(mentor_id = @current_user_mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: {"authorization" => @auth_token })
    raise Kele::InvalidMentorID if response.code != 200

    @current_user_mentor_availability = JSON.parse(response.body)
  end

  private

  #set_my_attributs is a private call to list other methods for setting current_user attributes
  def set_my_attributes
    get_my_mentor_id
    get_my_enrollment_id
  end

  #called by set_my_attributes, this will set the current_user_mentor_id attribute
  def get_my_mentor_id
    @current_user_mentor_id = current_user["current_enrollment"]["mentor_id"]
  end

  def get_my_enrollment_id
    puts "Testing Enrollment ID Call"
    @current_user_enrollment_id = current_user["current_enrollment"]["id"]
  end

end

class Kele::InvalidCredentials < StandardError; end
class Kele::InvalidMentorID < StandardError; end
class Kele::NoUserDefined < StandardError; end
