class Station
  include InstanceCounter

  NAME_FORMAT = /^[а-я\d]{1}[а-я \d-]{1,48}[а-я\d]{1}$/i

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    raise "Название станции несоответствует устновленному формату." if !valid?
    @trains = []
    register_instance(self)
  end

  def valid?
    (@name =~ NAME_FORMAT) != nil
  end

  def take(train)
    # принять поезд на станции
    self.trains << train
    return "Внимание! На станцию #{name} прибыл #{train}"
  end

  def send(train)
    # отправить поезд со станции
    trains.delete(train)
    return "Внимание! Со станции #{name} отправляется #{train}"
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end

  def to_s
    name
  end
end