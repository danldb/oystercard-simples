class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :current_journey, :journey_log

  def initialize(journey_log = JourneyLog.new)
    @balance = 0
    @journey_log = journey_log
  end

  def top_up(amount_received)
    self.balance += amount_received
    raise "Over limit of £#{MAXIMUM_BALANCE}" if above_maximum_balance?
  end

  def in_journey?
    !current_journey.nil?
  end

  def touch_in(journey)
    raise "Too low funds" if below_minimum_balance?
    self.current_journey = journey
  end

  def touch_out(station)
    current_journey.exit(station)
    journey_log.add(current_journey)
    self.current_journey = nil
    deduct(journey_fare)
  end

  private

  attr_writer :balance, :current_journey

  def journey_fare
    1
  end

  def deduct(amount_deducted)
    self.balance -= amount_deducted
  end

  def below_minimum_balance?
    balance < MINIMUM_BALANCE
  end

  def above_maximum_balance?
    balance > MAXIMUM_BALANCE
  end

end
