require "fare"

describe Fare do

  subject(:fare){ described_class }

  let(:entry_station){ double :entry_station }
  let(:exit_station){ double :exit_station }
  let(:journey){ {entry_station: entry_station, exit_station: exit_station} }

  it "returns a penalty fare by default" do
    expect(fare.calculate).to eq(Fare::PENALTY_FARE)
  end

  it "returns a penalty fare if only given entry station" do
    expect(fare.calculate({entry_station: entry_station})).to eq(Fare::PENALTY_FARE)
  end

  it "returns a penalty fare if only given exit station" do
    expect(fare.calculate(exit_station: exit_station)).to eq(Fare::PENALTY_FARE)
  end

  it "returns a fare of 1 when travelling within zone 1" do
    update_zones(1,1)
    expect(fare.calculate(journey)).to eq(1)
  end

  it "returns a fare of 2 when travelling between zones 1 and 2" do
    update_zones(1,2) 
    expect(fare.calculate(journey)).to eq(2)
  end

  def update_zones(entry_zone, exit_zone)
    allow(entry_station).to receive(:zone).and_return(entry_zone)
    allow(exit_station).to receive(:zone).and_return(exit_zone)
  end
end
