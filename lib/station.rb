class Station
  attr_reader :name

  STATIONS = {
              old_street: 1,
              whitechapel: 2
             }

  def initialize(name:)
    @name = name
  end

  def zone
    STATIONS[name]
  end
end
