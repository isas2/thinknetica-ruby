class Carriage
  attr_reader :number

  def initialize(number)
    @number = number
  end

  def type
  end

  def type_to_s
    return type == :cargo ? "грузовой" : "пассажирский" if type
  end

  def to_s
    "#{type_to_s} вагон №#{number}"
  end
end