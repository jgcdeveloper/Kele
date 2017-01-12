require 'spec_helper'

RSpec.describe Checkpoints do

  let(:kele) { Kele.new(ENV['BLOC_EMAIL'], ENV['BLOC_PASSWORD'],'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1') {include Checkpoints} }

  describe "checkpoint submission" do

    it "will throw an exception if current_user has not been set" do
      expect { kele.create_submission("2162","submission_branch","submission_link","Comment") }.to raise_exception(Kele::NoUserDefined)
    end

  end

end
