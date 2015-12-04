class JourneyLog

  def initialize
    @journeys = []
  end

  def completed_journeys
    journeys.dup
  end

  def record(journey)
    journeys << journey
  end

  private

  attr_reader :journeys
end
