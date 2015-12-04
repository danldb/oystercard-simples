require 'forwardable'

class Oystercard
  extend Forwardable

  def_delegator :@journey_manager, :journey_history, :journey_log

  LIMIT = 90
  MINIMUM_CHARGE = 1

  def initialize(account: Account.new, journey_manager: JourneyManager.new)
    @journey_manager = journey_manager
    @account = account
  end

  def top_up(amount_received)
    account.top_up(amount_received)
  end

  def touch_in(station)
    raise "You don't have enough" if balance < MINIMUM_CHARGE
    journey_manager.start(station)
  end

  def touch_out(station)
    journey_manager.exit(station)
  end

  def balance
    account.balance(journey_log)
  end
  
  private

  attr_reader :journey_manager, :account

end
