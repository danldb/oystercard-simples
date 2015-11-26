require 'forwardable'

class Oystercard
  extend Forwardable

  LIMIT = 90
  MINIMUM_CHARGE = 1

  attr_reader :balance

  def initialize(journey_log: JourneyLog)
    @journey_log = journey_log
    @balance = 0
  end

  def_delegator :@journey_log, :completed_journeys, :journey_history
  def_delegator :@journey_log, :current_journey

  def top_up(amount_received)
    self.balance += amount_received
    raise "Over limit of £#{LIMIT}" if balance > LIMIT
  end

  def deduct(amount_deducted)
    self.balance -= amount_deducted
  end

  def in_journey?
    !!current_journey
  end

  def touch_in(station)
    raise "You don't have enough" if balance < MINIMUM_CHARGE
    journey_log.start_journey(station)
  end

  def touch_out(station)
    journey_log.exit_journey(station)
  end

  private

  attr_writer :balance
  attr_reader :journey_log

end
