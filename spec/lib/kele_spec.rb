require 'spec_helper'

RSpec.describe Kele do

  let(:kele_authorized) { Kele.new( ENV['BLOC_EMAIL'], ENV['BLOC_PASSWORD'],'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}
  let(:kele_unauthorized) { Kele.new("antblessing@gmail.com","password",'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}

  describe "HTTP Responses" do

    it "Returns 200 for an accepted connection with accepted credentials" do
      expect(kele_authorized.http_response).to eq(200)
    end

    it "Returns 403 for an improper login credentials" do
      expect(kele_unauthorized.http_response).to eq(403)
    end

  end

  describe "Attributes" do

    it "Has an the required attributes" do
      expect(kele_authorized).to have_attributes(
        auth_token: kele_authorized.auth_token,
        http_response: kele_authorized.http_response,
        current_user: kele_authorized.current_user,
        current_user_mentor_id: kele_authorized.current_user_mentor_id,
        current_user_mentor_availability: kele_authorized.current_user_mentor_availability
      )
    end

  end

  describe "authentication tokens" do

    it "Provides an auth_token for an authorized user" do
      expect(kele_authorized.auth_token).to_not be_nil
    end

    it "Does not provide auth_token for an unauthorized user" do
      expect(kele_unauthorized.auth_token).to be_nil
    end

  end

  describe "Exceptions" do

    it "can raise an invalid token exception" do
      expect { raise Kele::InvalidAuthTokenError }.to raise_exception(Kele::InvalidAuthTokenError)
    end

    it "can raise an invalid mentor id exception" do
      expect { raise Kele::InvalidMentorID }.to raise_exception(Kele::InvalidMentorID)
    end

  end

  describe "Calling get_me without a valid auth_token" do

    it "Will raise an exception" do
      expect { kele_unauthorized.get_me }.to raise_exception(Kele::InvalidAuthTokenError)
    end

  end


  describe "Calling get_me with a valid auth_token" do

    before(:example) do
      kele_authorized.get_me
    end

    it "Will set data to @current_user with an authorization token" do
      expect(kele_authorized.current_user).to_not be_nil
    end

    it "Has several of the expected hash keys in the returned body" do
      expect(kele_authorized.current_user["id"]).to_not be_nil
      expect(kele_authorized.current_user["name"]).to_not be_nil
      expect(kele_authorized.current_user["email"]).to_not be_nil
    end

    it "Does not find an invalid hash key" do
      expect(kele_authorized.current_user["invalid"]).to be_nil
    end

    it "Calls a method for setting attributes" do
      expect(kele_authorized).to receive(:set_my_attributes)
      kele_authorized.get_me
    end

    it "Returns nil" do
      expect(kele_authorized.get_me).to eq(nil)
    end

  end

  describe "Calling get_mentor_availability without a defined mentor ID" do

    it "Will raise an exception" do
      expect { kele_unauthorized.get_mentor_availability }.to raise_exception(Kele::InvalidMentorID)
    end

  end

  describe "Calling get_mentor_availability with a valid mentor ID" do

    before(:example) do
      kele_authorized.get_me
      kele_authorized.get_mentor_availability
    end

    it "Will set data to @current_user_mentor_availability with an authorization token" do
      expect(kele_authorized.current_user_mentor_availability).to_not be_nil
    end

  end

end
