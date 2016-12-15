RSpec.describe Kele do

  let(:kele_mock) { Kele.new("antblessing@gmail.com","password",'https://private-anon-840be6fd6b-blocapi.apiary-mock.com/api/v1')}
  let(:kele_unauthorized) { Kele.new("username","password",'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}
  let(:kele_authorized) { Kele.new("","",'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1')}

  describe "attributes" do

    it "has an user_token attribute" do
      expect(kele_unauthorized).to have_attributes(user_token: kele_unauthorized.user_token)
      puts kele_unauthorized.user_token
    end

    it "has an user_token attribute" do
      expect(kele_mock).to have_attributes(user_token: kele_mock.user_token)
      puts kele_mock.user_token
    end

  end

end
