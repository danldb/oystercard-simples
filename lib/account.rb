class Account

  LIMIT = 90

  def initialize(fare: Fare)
    @top_ups = []
    @fare = fare
  end

  def top_up(amount)
    raise "Over limit of £#{LIMIT}" if over_limit?(amount)
    top_ups << amount
  end

  def balance(journeys = [])
    total_top_ups - total_fares(journeys)
  end

  private

  attr_reader :top_ups, :fare

  def over_limit?(amount)
    balance + amount >= LIMIT
  end

  def total_top_ups
    top_ups.inject(&:+) || 0
  end

  def total_fares(journeys)
    fares = journeys.map {|journey| fare.calculate(journey) }
    fares.inject(&:+) || 0
  end
end
