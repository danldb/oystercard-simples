require "forwardable"

class JourneyManager
  extend Forwardable

  def_delegator :@journey_log, :completed_journeys, :journey_history

  def initialize(journey_klass = Journey, journey_log = JourneyLog.new)
    @journey_klass = journey_klass
    @journey_log = journey_log
  end

  def start(station = nil)
    record_current_journey if current_journey
    self.current_journey = journey_klass.new(station)
  end

  def exit(station)
    start unless current_journey
    current_journey.terminate(station)
    record_current_journey
  end

  private

  attr_accessor :current_journey
  attr_reader :journey_klass, :journey_log

  def record_current_journey
    journey_log.record(current_journey)
    current_journey = nil
  end
end
