class Fare

  PENALTY_FARE = 6

  def initialize(journey:)
    @journey = journey
  end

  def value 
    return PENALTY_FARE if penalty?
    zones.inject(:-) + 1
  end

  private

  attr_reader :journey

  def penalty?
    !(journey.entry_station && journey.exit_station)
  end

  def zones
    [journey.entry_station, journey.exit_station].map(&:zone).sort{|a,b| b <=> a }
  end
end
