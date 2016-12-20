require 'spec_helper'

RSpec.describe Kele do

  let(:kele_authorized) { Kele.new( ENV['BLOC_EMAIL'], ENV['BLOC_PASSWORD'],'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}
  let(:kele_unauthorized) { Kele.new("antblessing@gmail.com","password",'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}

  describe "Initialization" do

    it "completes initialization with a valid password" do
      expect(kele_authorized).to_not be_nil
    end

    it "does not return valid response for invalid credentials" do
      expect { kele_unauthorized }.to raise_exception(Kele::InvalidCredentials)
    end

    it "Provides an #auth_token for an authorized user" do
      expect(kele_authorized.auth_token).to_not be_nil
    end

  end

  describe "Attributes" do

    it "Has an the required attributes" do
      expect(kele_authorized).to have_attributes(
        auth_token: kele_authorized.auth_token,
        current_user: kele_authorized.current_user,
        current_user_mentor_id: kele_authorized.current_user_mentor_id,
        current_user_mentor_availability: kele_authorized.current_user_mentor_availability
      )
    end

  end

  describe "Exceptions" do

    it "can raise an invalid credential exception" do
      expect { raise Kele::InvalidCredentials }.to raise_exception(Kele::InvalidCredentials)
    end

    it "can raise an invalid mentor id exception" do
      expect { raise Kele::InvalidMentorID }.to raise_exception(Kele::InvalidMentorID)
    end

  end

  describe "Calling .get_me" do

    before(:example) do
      kele_authorized.get_me
    end

    it "Will set data in #current_user" do
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

    it "Calls .set_my_attributes for setting attributes" do
      expect(kele_authorized).to receive(:set_my_attributes)
      kele_authorized.get_me
    end

    it "Returns nil" do
      expect(kele_authorized.get_me).to eq(nil)
    end

  end

  describe "Calling .get_mentor_availability with an incorrect mentor ID" do

    it "Will raise an exception" do
      expect { kele_authorized.get_mentor_availability(0) }.to raise_exception(Kele::InvalidMentorID)
    end

  end

  describe "Calling .get_mentor_availability with a valid mentor ID" do

    before(:example) do
      kele_authorized.get_me
      kele_authorized.get_mentor_availability
    end

    it "Will set data to #current_user_mentor_availability" do
      expect(kele_authorized.current_user_mentor_availability).to_not be_nil
    end

  end

end
