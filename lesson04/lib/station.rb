class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def take(train)
    # принять поезд на станции
    puts "Внимание! На станцию #{name} прибыл #{train}"
    self.trains << train
  end

  def send(train)
    # отправить поезд со станции
    puts "Внимание! Со станции #{name} отправляется #{train}"
    trains.delete(train)
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end

  def to_s
    name
  end
end