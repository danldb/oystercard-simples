class JourneyLog

  attr_reader :current_journey

  def initialize
    @journeys = []
  end

  def start_journey(station)
    self.current_journey = {entry_station: station}
  end

  def exit_journey(station)
    self.current_journey[:exit_station] = station
    record_current_journey
  end

  def completed_journeys
    journeys.dup
  end

  private

  attr_accessor :journeys
  attr_writer :current_journey

  def record_current_journey
    journeys << current_journey
    self.current_journey = nil
  end
end
