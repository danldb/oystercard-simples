class Journey
  attr_reader :exit_station, :entry_station

  def initialize(entry_station = nil)
    @entry_station = entry_station
  end

  def terminate(station)
    raise "This journey has already terminated" if exit_station
    @exit_station = station
  end
end
