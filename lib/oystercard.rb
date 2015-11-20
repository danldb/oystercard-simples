class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  NO_CHARGE = 0

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
    conclude_active_journey
    raise "Too low funds" if below_minimum_balance?
    self.current_journey = journey
  end

  def touch_out(station, new_journey = Journey.new)
    current_journey = new_journey unless current_journey
    current_journey.set_exit(station)
    conclude_active_journey
    self.current_journey = nil
  end

  private

  attr_writer :balance, :current_journey

  def conclude_active_journey
    journey_log.add(current_journey) if current_journey
    deduct_outstanding_balance
  end

  def journey_fare
    current_journey ? current_journey.fare : NO_CHARGE
  end

  def deduct_outstanding_balance 
    self.balance -= journey_fare
  end

  def below_minimum_balance?
    balance < MINIMUM_BALANCE
  end

  def above_maximum_balance?
    balance > MAXIMUM_BALANCE
  end

end
