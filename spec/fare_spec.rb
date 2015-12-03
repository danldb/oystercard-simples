require "fare"

describe Fare do

  subject(:fare){ described_class.new(journey: journey) }

  let(:entry_station){ double :entry_station, zone: 1 }
  let(:exit_station){ double :exit_station, zone: 1 }
  let(:journey){ double :journey, entry_station: entry_station, exit_station: exit_station }

  it "returns a penalty fare if only given entry station" do
    allow(journey).to receive(:exit_station).and_return(nil)
    expect(fare.value).to eq(Fare::PENALTY_FARE)
  end

  it "returns a penalty fare if only given exit station" do
    allow(journey).to receive(:entry_station).and_return(nil)
    expect(fare.value).to eq(Fare::PENALTY_FARE)
  end

  it "returns a fare of 1 when travelling within zone 1" do
    update_zones(1,1)
    expect(fare.value).to eq(1)
  end

  it "returns a fare of 2 when travelling between zones 1 and 2" do
    update_zones(1,2) 
    expect(fare.value).to eq(2)
  end

  def update_zones(entry_zone, exit_zone)
    allow(entry_station).to receive(:zone).and_return(entry_zone)
    allow(exit_station).to receive(:zone).and_return(exit_zone)
  end
end
