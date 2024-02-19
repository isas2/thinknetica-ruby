class CargoCarriage < Carriage
  def initialize(number, capacity=138)
    super(number, capacity)
    @type = :cargo
  end

  def add_cargo(volume)
    add_volume(volume)
  end
end