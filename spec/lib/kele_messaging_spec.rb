require 'spec_helper'
require 'stringio'

RSpec.describe Messaging do

  let(:kele) { Kele.new(ENV['BLOC_EMAIL'], ENV['BLOC_PASSWORD'],'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1') {include Messaging} }

  describe "get messages" do

    let(:messages) { kele.get_messages }

    it "does not return nil" do
      expect(kele.get_messages).to_not be_nil
    end

    it "will return a valid message format" do
      expect(messages[0]["token"]).to_not be_nil
    end

    it "will throw an exception if user requests page 0" do
      expect { kele.get_messages(0) }.to raise_exception(Messaging::InvalidPageNumber)
    end

  end

  describe "get message count" do

    it "retrieves message count from the correct location" do
      expect(kele.retrieve_message_count_from_server).to_not be_nil
    end

    it "have a count greater then zero" do
      expect(kele.retrieve_message_count_from_server).to_not eq(0)
    end

  end

  describe "calling create message with no user defined" do

    it "raises an exception error if current user has not been set" do
      expect { kele.create_message }.to raise_exception(Messaging::NoUserDefined)
    end
    
  end

#  describe "calling create message with user defined" do
#
#    it "should ask for a message subject if no token is defined" do
#      kele.get_me
#      expect(kele.create_message).to receive(:set_message_subject)
#    end
#
#  end

end
