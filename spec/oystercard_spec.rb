require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new }

  let(:station) { double :station }

  it "has a balance" do
    expect(oystercard.balance).to eq(0)
  end

  it "can be topped up with an amount of money" do
    oystercard.top_up(10)
    expect(oystercard.balance).to eq(10)
  end

  it "prevents more than the limit on the oystercard being topped up" do
    large_amount = described_class::LIMIT + 10
    expect { oystercard.top_up(large_amount) }.to raise_error("Over limit of £90")
  end

  it "by default does not have an active journey" do
    expect(oystercard).to_not be_in_journey
  end

  it "will not touch in if below minimum balance" do
    expect{ oystercard.touch_in(station) }.to raise_error("You don't have enough")
  end

  it "deducts money from the card" do
    oystercard.top_up(20)
    oystercard.deduct(10)
    expect(oystercard.balance).to eq(10)
  end

  context "when touched in" do

    before do
      oystercard.top_up(20)
      oystercard.touch_in(station)
    end

    it "stores the entry station" do
      expect(oystercard.entry_station).to eq(station)
    end

    it "is in a journey" do
      expect(oystercard).to be_in_journey
    end

    it "is not in a journey when the user has touched out" do
      oystercard.touch_out
      expect(oystercard).to_not be_in_journey
    end

    it "has no entry station after touch_out" do
      oystercard.touch_out
      expect(oystercard.entry_station).to be_nil
    end

  end
end
