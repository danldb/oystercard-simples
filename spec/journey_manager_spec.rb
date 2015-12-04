require "journey_manager"

describe JourneyManager do
  subject(:journey_manager){ described_class.new(journey_klass, journey_log) }
  let(:journey_klass){ double :journey_klass, new: journey }
  let(:journey){ spy :journey }
  let(:journey_log){ spy :journey_log }

  it "starts a journey" do
    expect(journey_klass).to receive(:new).with(:station)
    journey_manager.start(:station)
  end

  it "exits a journey" do
    expect(journey_klass).to receive(:new)
    journey_manager.exit(:station)
  end

  it "has a journey log" do
    journey_manager.journey_history
    expect(journey_log).to have_received(:completed_journeys)
  end
  
  context "when a journey is in progress" do
    before do
      journey_manager.start(:station)
    end

    it "terminates journey when new journey is started" do
      journey_manager.start(:station)
      expect(journey_log).to have_received(:record).with(journey)
    end

    context "when a journey is completed" do
      before do
        journey_manager.exit(:station)
      end

      it "terminates a journey" do
        expect(journey).to have_received(:terminate).with(:station)
      end

      it "stores a completed journey" do
        expect(journey_log).to have_received(:record).with(journey)
      end

      it "resets previous journey before storing new journey" do
        journey_manager.exit(:station)
        expect(journey_log).to have_received(:record).twice
      end
    end
  end
end
