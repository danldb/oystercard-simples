class Journey

  attr_reader :exit_station, :entry_station

  PENALTY_FARE = 6

  def initialize(entry_station = nil)
    @entry_station = entry_station
  end

  def set_exit(station)
    @exit_station = station
  end

  def fare
    return PENALTY_FARE if penalty?
    zones.inject(:-) + 1
  end

  private

  def penalty?
    !(entry_station && exit_station)
  end

  def zones
    [entry_station, exit_station].map(&:zone).sort{|a,b| b <=> a }
  end
end
