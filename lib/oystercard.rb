require 'forwardable'

class Oystercard
  extend Forwardable

  def_delegator :@journey_log, :completed_journeys, :journey_history

  LIMIT = 90
  MINIMUM_CHARGE = 1

  def initialize(journey_log: JourneyLog.new, account: Account.new)
    @journey_log = journey_log
    @account = account
  end

  def top_up(amount_received)
    account.top_up(amount_received)
  end

  def touch_in(station)
    raise "You don't have enough" if balance < MINIMUM_CHARGE
    journey_log.start_journey(station)
  end

  def touch_out(station)
    journey_log.exit_journey(station)
  end

  def balance
    account.balance(journey_history)
  end
  
  private

  attr_reader :journey_log, :account

end
