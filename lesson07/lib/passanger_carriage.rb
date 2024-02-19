class PassangerCarriage < Carriage
  def initialize(number, capacity=54)
    super(number, capacity)
    @type = :passenger
  end

  def add_passenger
    add_volume(1)
  end
end