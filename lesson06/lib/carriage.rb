class Carriage
  include Vehicle

  NUMBER_FORMAT = /^[а-я]{2}\d{5}$/i

  attr_reader :number, :type

  def initialize(number)
    @number = number
    raise "Номер вагона несоответствует устновленному формату." if !valid?
  end

  def valid?
    (@number =~ NUMBER_FORMAT) != nil
  end

  def self.random_number
    ('а'..'я').to_a.shuffle[0, 2].join + ('0'..'9').to_a.shuffle[0, 5].join
  end

  def to_s
    "#{Carriage.types[type]} вагон №#{number}"
  end
end