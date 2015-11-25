require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new }

  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

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
    expect{ oystercard.touch_in(entry_station) }.to raise_error("You don't have enough")
  end

  it "deducts money from the card" do
    oystercard.top_up(20)
    oystercard.deduct(10)
    expect(oystercard.balance).to eq(10)
  end

  it "has an empty list of journeys" do
    expect(oystercard.journeys).to be_empty
  end

  context "when touched in" do

    before do
      oystercard.top_up(20)
      oystercard.touch_in(entry_station)
    end

    it "is in a journey" do
      expect(oystercard).to be_in_journey
    end

    context "when touching out" do

      let(:journey){ {entry_station: entry_station, exit_station: exit_station} }
      before do
        oystercard.touch_out(exit_station)
      end
      
      it "is not in a journey when the user has touched out" do
        expect(oystercard).not_to be_in_journey
      end

      it "stores a journey" do
        expect(oystercard.journeys.last).to eq(journey)
      end
    end
  end
end
