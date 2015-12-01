require "account"

describe Account do

  subject(:account){ described_class.new(fare: fare) }

  let(:fare){ double :fare }
  let(:journey) { double :journey }

  it "has a balance of zero by default" do
    expect(account.balance).to eq(0)
  end

  it "checks fare when journey is stored" do
    expect(fare).to receive(:calculate)
    account.balance([journey])
  end


  describe "topping up" do

    it "can be topped up" do
      account.top_up(20)
      expect(account.balance).to eq(20)
    end

    it "prevents more than the limit on the oystercard being topped up" do
      large_amount = described_class::LIMIT + 10
      expect { account.top_up(large_amount) }.to raise_error("Over limit of £90")
    end

  end

  context "topped up with 20" do
    before do
      account.top_up(20)
    end

    it "has a balance of 0 after a journey costing 20" do
      allow(fare).to receive(:calculate).and_return(20)
      expect(account.balance([journey])).to eq(0)
    end

    it "has a balance of 10 after two journeys of 5" do
      allow(fare).to receive(:calculate).and_return(5)
      expect(account.balance([journey, journey])).to eq(10)
    end

    it "has a balance of -10 after three journeys of 10" do
      allow(fare).to receive(:calculate).and_return(10)
      expect(account.balance([journey, journey, journey])).to eq(-10)
    end
  end
end
