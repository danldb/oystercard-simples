require 'journey'

describe Journey do
  subject(:journey){ described_class.new(entry_station) }

  let(:entry_station){ double :station }
  let(:exit_station){ double :station }

  it "stores an entry station" do
    expect(journey.entry_station).to eq(entry_station)
  end

  it "stores an exit station" do
    journey.terminate(exit_station)
    expect(journey.exit_station).to eq(exit_station)
  end

  it "will not store subsequent exit station" do
    already_terminated = "This journey has already terminated"
    journey.terminate(exit_station)
    expect{journey.terminate(exit_station)}.to raise_error(already_terminated)
  end

  context "no entry station" do
    subject(:journey){ described_class.new }

    it "has no entry station" do
      expect(journey.entry_station).to be_nil
    end
  end
end
