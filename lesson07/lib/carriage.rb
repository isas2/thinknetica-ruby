class Carriage
  include Vehicle

  NUMBER_FORMAT = /^[а-я]{2}\d{5}$/i

  attr_reader :number, :type, :capacity, :volume

  def initialize(number, capacity)
    @number = number
    raise "Номер вагона несоответствует устновленному формату." if !valid_number?
    @capacity = capacity
    raise "Некорректный тип или значение вместимости вагона." if !valid_capacity?
    @volume = 0
  end

  def valid?
    valid_number? && valid_capacity?
  end

  def valid_number?
    (@number =~ NUMBER_FORMAT) != nil
  end

  def valid_capacity?
    @capacity.is_a?(Numeric) && @capacity.between?(1, 150)
  end

  def free_volume
    @capacity - @volume
  end

  def self.random_number
    ('а'..'я').to_a.shuffle[0, 2].join + ('0'..'9').to_a.shuffle[0, 5].join
  end

  def to_s
    "#{Carriage.types[type]} вагон №#{number}"
  end

  protected

  def add_volume(value)
    raise "Превышена вместимость вагона" if @volume + value > @capacity
    @volume += value
  end
end