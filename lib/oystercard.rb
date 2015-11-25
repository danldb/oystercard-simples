class Oystercard

  LIMIT = 90
  MINIMUM_CHARGE = 1

  attr_reader :balance, :journeys

  def initialize
    @balance = 0
    @journeys = []
    @current_journey = {}
  end

  def top_up(amount_received)
    self.balance += amount_received
    raise "Over limit of £#{LIMIT}" if balance > LIMIT
  end

  def deduct(amount_deducted)
    self.balance -= amount_deducted
  end

  def in_journey?
    !current_journey.empty?
  end

  def touch_in(station)
    raise "You don't have enough" if balance < MINIMUM_CHARGE
    current_journey[:entry_station] = station
  end

  def touch_out(station)
    current_journey[:exit_station] = station
    store_current_journey 
  end

  private

  attr_accessor :current_journey
  attr_writer :balance

  def store_current_journey
    journeys << current_journey
    self.current_journey = {}
  end
end
