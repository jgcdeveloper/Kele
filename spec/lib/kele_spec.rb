RSpec.describe Kele do

  let(:kele_unauthorized) { Kele.new("antblessing@gmail.com","password",'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}
  let(:kele_authorized) { Kele.new(ENV["BLOC_EMAIL"],ENV["BLOC_PASSWORD"],'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}

  describe "HTTP Response Codes" do

    it "Returns 200 for an accepted connection with accepted credentials" do
      expect(kele_authorized.response).to eq(200)
    end

    it "Returns 403 for an improper login credentials" do
      expect(kele_unauthorized.response).to eq(403)
    end

  end

  describe "attributes" do

    it "Has an auth_token and response attribute" do
      expect(kele_authorized).to have_attributes(auth_token: kele_authorized.auth_token, response: kele_authorized.response)
    end

    it "Provides an auth_token for an authorized user" do
      expect(kele_authorized.auth_token).to_not be_nil
    end

    it "Does not provide auth_token for an unauthorized user" do
      expect(kele_unauthorized.auth_token).to be_nil
    end

  end

end
