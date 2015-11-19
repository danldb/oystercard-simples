require "journey"

describe Journey do

  subject(:journey){ described_class.new }

  let(:exit_station) {double :exit_station}
  let(:entry_station) {double :entry_station }


  it "returns the penalty fare by default" do
    expect(journey.fare).to eq Journey::PENALTY_FARE 
  end

  it "returns the penalty fare given only an exit station" do
    journey.set_exit(exit_station)
    expect(journey.fare).to eq Journey::PENALTY_FARE
  end

  context "given an entry station" do

    subject(:journey){ described_class.new(entry_station) }

    it "records the entry station" do
      expect(journey.entry_station).to eq(entry_station)
    end

    it "returns the penalty fare if no exit station is given" do
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    context "given an exit station" do

      before do
        journey.set_exit(exit_station)
      end

      it "records an exit station" do
        expect(journey.exit_station).to eq(exit_station)
      end

      it "calculates a fare for zones 1 and 1" do
        update_zones(1,1)
        expect(journey.fare).to eq(1)
      end

      it "calculates the fare from zone 1 to zone 2" do
        update_zones(1,2)
        expect(journey.fare).to eq(2)
      end

      it "calculates the fare from zone 2 to zone 1" do
        update_zones(2,1)
        expect(journey.fare).to eq(2)
      end

      it "calculates the fare from zone 6 to zone 5" do
        update_zones(6,5)
        expect(journey.fare).to eq(2)
      end

      it "calculates the fare from zone 5 to zone 6" do
        update_zones(5,6)
        expect(journey.fare).to eq(2)
      end

      it "calculates the fare from zone 6 to zone 1" do
        update_zones(6,1)
        expect(journey.fare).to eq(6)
      end

      def update_zones(entry_zone, exit_zone)
        allow(entry_station).to receive(:zone).and_return(entry_zone)
        allow(exit_station).to receive(:zone).and_return(exit_zone)
      end
    end
  end
end
