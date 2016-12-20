require 'spec_helper'

RSpec.describe Roadmap do

  let(:kele_authorized) { Kele.new(ENV['BLOC_EMAIL'], ENV['BLOC_PASSWORD'],'https://private-anon-840be6fd6b-blocapi.apiary-proxy.com/api/v1') {include Roadmap} }

  describe "roadmap retrieval" do

    it "will store the roadmap back into #roadmap client variable" do
      kele_authorized.get_roadmap(ENV['ROADMAP_ID'])
      expect(kele_authorized.roadmap).to_not be_nil
    end

    it "will throw an exception with an incorrect roadmap ID" do
      expect { kele_authorized.get_roadmap(0) }.to raise_exception(Roadmap::InvalidRoadmapIDError)
    end

  end

  describe "checkpoint retrieval" do

    it "will store the checkpoint back into #checkpoint client variable" do
      kele_authorized.get_checkpoint( ENV['CHECKPOINT_ID'] )
      expect(kele_authorized.checkpoint).to_not be_nil
    end

    it "will throw an exception with an invalid checkpoint ID" do
      expect { kele_authorized.get_checkpoint(0) }.to raise_exception(Roadmap::InvalidCheckpointIDError)
    end

    it "will throw an exception with an inaccessable to user checkpoint ID" do
      #Again, what is inaccessable depends on user, so the call has been mapped to an environmental value
      expect { kele_authorized.get_checkpoint( ENV['INVALID_CHECKPOINT'] ) }.to raise_exception(Roadmap::InvalidCheckpointIDError)
    end

  end

  describe "exceptions" do
    it "can raise an invalid roadmap ID error" do
      expect { raise Roadmap::InvalidRoadmapIDError }.to raise_exception(Roadmap::InvalidRoadmapIDError)
    end

    it "can raise an invalid checkpoint ID error" do
      expect { raise Roadmap::InvalidCheckpointIDError }.to raise_exception(Roadmap::InvalidCheckpointIDError)
    end

  end

end
