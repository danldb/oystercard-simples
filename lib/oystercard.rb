class Oystercard

  LIMIT = 90
  MINIMUM_CHARGE = 1

  attr_reader :balance, :entry_station

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount_received)
    self.balance += amount_received
    raise "Over limit of £#{LIMIT}" if balance > LIMIT
  end

  def deduct(amount_deducted)
    self.balance -= amount_deducted
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(station)
    raise "You don't have enough" if balance < MINIMUM_CHARGE
    self.entry_station = station
    self.in_journey = true
  end

  def touch_out
    self.entry_station = nil
    self.in_journey = false
  end

  private

  attr_writer :balance, :entry_station
  attr_accessor :in_journey

end
