require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new(journey_log: journey_log, fare: fare) }

  let(:fare){ double :fare }
  let(:journey_log){ double :journey_log, current_journey: {}, exit_journey: nil, start_journey: nil }
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

    let(:journey){ {entry_station: entry_station} }

    before do
      oystercard.top_up(20)
    end

    it "starts a journey" do
      expect(journey_log).to receive(:start_journey).with(entry_station)
      oystercard.touch_in(entry_station)
    end

    it "has a balance" do
      expect(oystercard.balance).to eq(20)
    end

    it "checks the fare when touching in twice" do
      allow(journey_log).to receive(:current_journey).and_return(journey)
      expect(fare).to receive(:calculate).with(journey).and_return(1)
      oystercard.touch_in(entry_station)
    end

    context "when touched in" do

      before do
        allow(journey_log).to receive(:current_journey).and_return(journey)
      end

      it "is in a journey" do
        expect(oystercard).to be_in_journey
      end

      it "can exit a journey" do
        allow(journey_log).to receive(:completed_journeys).and_return([journey])
        allow(fare).to receive(:calculate).with(journey).and_return(2)
        expect(journey_log).to receive(:exit_journey).with(exit_station)
        oystercard.touch_out(exit_station)
      end

      it "deducts the fare upon touch out" do
        allow(fare).to receive(:calculate).with(journey).and_return(2)
        allow(journey_log).to receive(:completed_journeys).and_return([journey])
        oystercard.touch_out(exit_station)
        expect(oystercard.balance).to eq(20 - 2)
      end

      it "closes previous journey if already touched in" do
        allow(fare).to receive(:calculate).with(journey).and_return(2)
        expect(journey_log).to receive(:exit_journey).with(no_args)
        allow(journey_log).to receive(:start_journey)
        oystercard.touch_in(entry_station)
      end
    end
  end
end
