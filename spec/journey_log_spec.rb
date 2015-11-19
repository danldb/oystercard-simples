require "journey_log"

describe JourneyLog do
  subject(:journey_log){ described_class.new }
  let(:journey){ :journey }
  it "can store a journey" do
    journey_log.add(journey)
    expect(journey_log.journeys).to include(journey)
  end
end
