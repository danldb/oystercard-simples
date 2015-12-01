require 'journey_log'

describe JourneyLog do
  subject(:journey_log){ described_class.new }
  let(:entry_station){ :entry_station }
  let(:exit_station){ :exit_station }

  it "has no current journey by default" do
    expect(journey_log.current_journey).to be_empty
  end

  it "stores an incomplete journey when touching out without touching in" do
    journey_log.exit_journey
    expect(journey_log.completed_journeys.last).to have_key(:exit_station)
  end

  context "when a journey is started" do
    before do
      journey_log.start_journey(entry_station)
    end

    it "stores the entry station into the current journey" do
      expect(journey_log.current_journey[:entry_station]).to eq(entry_station)
    end

    it "has no completed journeys" do
      expect(journey_log.completed_journeys).to be_empty
    end

    it "is not possible to directly modify completed journeys" do
      journey_log.completed_journeys << :journey
      expect(journey_log.completed_journeys).to be_empty
    end

    it "starts a new journey if touched in twice" do
      journey = journey_log.current_journey
      journey_log.start_journey(entry_station)
      expect(journey_log.completed_journeys).to include(journey)
    end

    context "when a journey is complete" do
      let(:journey) do
        { entry_station: entry_station, exit_station: exit_station }
      end

      before do
        journey_log.exit_journey(exit_station)
      end

      it "has no current journey" do
        expect(journey_log.current_journey).to be_empty
      end

      it "has a completed journey" do
        expect(journey_log.completed_journeys).to include(journey)
      end
    end
  end
end
