class JourneyLog

  attr_reader :journeys

  def initialize
    @journeys = []
  end

  def add(journey)
    journeys << journey if journey
  end
end
