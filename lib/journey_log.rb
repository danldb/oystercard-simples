class JourneyLog

  def initialize
    @journeys = []
  end

  def start_journey(station)
    record_current_journey if in_journey?
    current_journey[:entry_station] = station 
  end

  def exit_journey(station = nil)
    current_journey[:exit_station] = station
    record_current_journey
  end

  def completed_journeys
    journeys.dup
  end

  def current_journey
    @current_journey ||= {}
  end

  private

  attr_reader :journeys
  attr_writer :current_journey

  def record_current_journey
    journeys << current_journey
    self.current_journey = nil
  end

  def in_journey?
   !current_journey.empty? 
  end
end
