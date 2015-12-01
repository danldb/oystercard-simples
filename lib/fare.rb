class Fare

  PENALTY_FARE = 6

  def self.calculate(journey = {})
    return PENALTY_FARE unless valid?(journey)
    zones(journey).inject(:-) + 1
  end

  private

  def self.valid?(journey)
    journey[:entry_station] && journey[:exit_station]
  end

  def self.zones(journey)
    [journey[:entry_station], journey[:exit_station]].map(&:zone).sort{|a,b| b <=> a }
  end
end
