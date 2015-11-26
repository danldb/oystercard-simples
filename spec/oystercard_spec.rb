require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new(journey_log: journey_log) }

  let(:journey_log){ double :journey_log}
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  it "has a balance" do
    expect(oystercard.balance).to eq(0)
  end

  it "prevents more than the limit on the oystercard being topped up" do
    large_amount = described_class::LIMIT + 10
    expect { oystercard.top_up(large_amount) }.to raise_error("Over limit of £90")
  end

  it "by default does not have an active journey" do
    allow(journey_log).to receive(:current_journey).and_return(nil)
    expect(oystercard).to_not be_in_journey
  end

  it "will not touch in if below minimum balance" do
    expect{ oystercard.touch_in(entry_station) }.to raise_error("You don't have enough")
  end


  it "has a journey history" do
    expect(journey_log).to receive(:completed_journeys)
    oystercard.journey_history
  end


  context "when topped up" do

    before do
      oystercard.top_up(20)
    end

    it "starts a journey" do
      expect(journey_log).to receive(:start_journey).with(entry_station)
      oystercard.touch_in(entry_station)
    end

    it "deducts money from the card" do
      oystercard.deduct(10)
      expect(oystercard.balance).to eq(10)
    end

    it "has a balance" do
      expect(oystercard.balance).to eq(20)
    end

    context "when touched in" do

      before do
        allow(journey_log).to receive(:start_journey)
        oystercard.touch_in(entry_station)
      end

      it "is in a journey" do
        allow(journey_log).to receive(:current_journey).and_return(:journey)
        expect(oystercard).to be_in_journey
      end

      it "can exit a journey" do
        expect(journey_log).to receive(:exit_journey).with(:exit_station)
        oystercard.touch_out(:exit_station)
      end
    end
  end
end
