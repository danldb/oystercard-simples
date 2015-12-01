require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new(journey_log: journey_log, account: account ) }

  let(:account){ double :account }
  let(:journey_log){ double :journey_log, completed_journeys: :journeys }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  it "has a balance" do
    expect(account).to receive(:balance).with(:journeys)
    oystercard.balance
  end

  it "sends a message to top up the account" do
    expect(account).to receive(:top_up).with(20)
    oystercard.top_up(20)
  end

  it "will not touch in if below minimum balance" do
    allow(account).to receive(:balance).and_return(0)
    expect{ oystercard.touch_in(entry_station) }.to raise_error("You don't have enough")
  end

  it "has a journey history" do
    expect(journey_log).to receive(:completed_journeys)
    oystercard.journey_history
  end


  context "when topped up" do

    let(:journey){ {entry_station: entry_station} }

    before do
      allow(account).to receive(:balance).and_return(20)
    end

    it "has a balance" do
      expect(oystercard.balance).to eq(20)
    end

    it "starts a journey" do
      expect(journey_log).to receive(:start_journey).with(entry_station)
      oystercard.touch_in(entry_station)
    end

    context "when touched in" do

      before do
        allow(journey_log).to receive(:current_journey).and_return(journey)
      end

      it "can exit a journey" do
        expect(journey_log).to receive(:exit_journey).with(exit_station)
        oystercard.touch_out(exit_station)
      end
    end
  end
end
