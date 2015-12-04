require 'journey_log'

describe JourneyLog do
  subject(:journey_log){ described_class.new }

  let(:journey){ double :journey }

  it "has no journeys by default" do
    expect(journey_log.completed_journeys).to be_empty
  end

  it "is not possible to directly modify completed journeys" do
    journey_log.completed_journeys << :journey
    expect(journey_log.completed_journeys).to be_empty
  end

  it "records a journey" do
    journey_log.record(journey)
    expect(journey_log.completed_journeys).to include(journey)
  end
end
