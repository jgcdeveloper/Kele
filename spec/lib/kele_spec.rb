RSpec.describe Kele do

  let(:kele_authorized) { Kele.new( ENV['BLOC_EMAIL'], ENV['BLOC_PASSWORD'],'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}
  let(:kele_unauthorized) { Kele.new("antblessing@gmail.com","password",'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}

  describe "Testing HTTP Response Codes" do

    it "Returns 200 for an accepted connection with accepted credentials" do
      expect(kele_authorized.http_response).to eq(200)
    end

    it "Returns 403 for an improper login credentials" do
      expect(kele_unauthorized.http_response).to eq(403)
    end

  end

  describe "Testing attributes" do

    it "Has an http_response, auth_token and current_user attributes" do
      expect(kele_authorized).to have_attributes(auth_token: kele_authorized.auth_token, http_response: kele_authorized.http_response, current_user: kele_authorized.current_user)
    end

    it "Provides an auth_token for an authorized user" do
      expect(kele_authorized.auth_token).to_not be_nil
    end

    it "Does not provide auth_token for an unauthorized user" do
      expect(kele_unauthorized.auth_token).to be_nil
    end

  end

  describe "Test calling get_me without a valid topic" do

    before(:example) do
      kele_unauthorized.get_me
    end

    it "Will not write data to @current_user without a authorization token" do
      expect(kele_unauthorized.current_user).to be_nil
    end

  end

  describe "Testing the get_me method with a valid token" do

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

  end

end
