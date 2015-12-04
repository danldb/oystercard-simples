require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new(journey_manager: journey_manager, account: account) }

  let(:account){ double :account }
  let(:journey_manager){ double :journey_manager, journey_history: :journeys }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  it "has a balance" do
    allow(journey_manager).to receive(:journey_log).and_return(:journeys)
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
    expect(journey_manager).to receive(:journey_history)
    oystercard.journey_log
  end

  it "can exit a journey" do
    expect(journey_manager).to receive(:exit).with(exit_station)
    oystercard.touch_out(exit_station)
  end

  context "when topped up" do

    before do
      allow(account).to receive(:balance).and_return(20)
    end

    it "has a balance" do
      expect(oystercard.balance).to eq(20)
    end

    it "starts a journey" do
      expect(journey_manager).to receive(:start).with(entry_station)
      oystercard.touch_in(entry_station)
    end

  end
end
