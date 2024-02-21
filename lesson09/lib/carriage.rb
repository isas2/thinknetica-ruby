# frozen_string_literal: true

class Carriage
  include Vehicle
  include Validation

  validate :number,   :presence
  validate :number,   :type,   String
  validate :number,   :format, /^[а-я]{2}\d{5}$/i
  validate :capacity, :type,   Integer
  validate :capacity, :in,     (1..150)

  attr_reader :number, :type, :capacity, :volume

  def initialize(number, capacity)
    @number = number
    @capacity = capacity
    raise 'Ошибка входных данных для нового вагона.' unless valid?

    @volume = 0
  end

  def free_volume
    @capacity - @volume
  end

  def self.random_number
    ('а'..'я').to_a.sample(2).join + ('0'..'9').to_a.sample(5).join
  end

  def to_s
    "#{Carriage.types[type]} вагон №#{number}"
  end

  protected

  def add_volume(value)
    raise 'Превышена вместимость вагона' if @volume + value > @capacity

    @volume += value
  end
end
