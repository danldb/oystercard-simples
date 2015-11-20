require 'oystercard'

describe Oystercard do

  subject(:oystercard){ described_class.new(journey_log)}

  let(:journey_log) { spy :journey_log }

  it "has a balance of £0" do
    expect(oystercard.balance).to eq(0)
  end

  it "by default is not in an active journey" do
    expect(oystercard).to_not be_in_journey
  end

  it "has an empty journey list by default" do
    expect(oystercard.journey_log).to eq(journey_log)
  end

  describe "Topping up" do

    it "can be topped up with an amount of money" do
      oystercard.top_up(10)
      expect(oystercard.balance).to eq(10)
    end

    it "prevents more than the limit on the oystercard being topped up" do
      large_amount = described_class::MAXIMUM_BALANCE + 10
      expect { oystercard.top_up(large_amount) }.to raise_error "Over limit of £90"
    end
  end

  describe "Touching in and out" do

    let(:journey) { spy :journey }
    
    let(:station) { :station }

    context "when touched in" do

      let(:second_journey) { double :second_journey, fare: 6 }
      before do
        oystercard.top_up(20)
        allow(journey).to receive(:fare).and_return(0)
        oystercard.touch_in(journey)
      end

      it "remembers the entry journey" do
        expect(oystercard.current_journey).to eq(journey)
      end

      it "is in an active journey" do
        expect(oystercard).to be_in_journey
      end

      it "will not store a journey if a current journey does not exit" do
        expect(journey_log).not_to have_received(:add)
      end

      it "remembers the exit station after touching out" do
        oystercard.touch_out(station)
        expect(journey).to have_received(:set_exit).with(station)
      end

      it "is not in an active journey when the user has touched out" do
        oystercard.touch_out(station)
        expect(oystercard).to_not be_in_journey
      end

      it "deducts the journey fare once the user touches out" do
        allow(journey).to receive(:fare).and_return(1)
        expect{ oystercard.touch_out(station) }.to change{ oystercard.balance }.by(-1)
      end

      it "stores a journey after you've touched in and out" do
        oystercard.touch_out(station)
        expect(journey_log).to have_received(:add).with(journey) 
      end

      context "when touching in twice" do

        it "stores previous journey"  do
          oystercard.touch_in(second_journey)
          expect(journey_log).to have_received(:add).with(journey)
        end

        it "charges user for previous journey" do
          allow(journey).to receive(:fare).and_return(1)
          expect{ oystercard.touch_in(second_journey) }.to change{ oystercard.balance }.by(-1)
        end
      end
    end

    context "without adequate funds for travel" do
      it "does not allow you to touch in when below the minimum fare" do
        expect { oystercard.touch_in(journey) }.to raise_error "Too low funds"
      end
    end

  end
end
