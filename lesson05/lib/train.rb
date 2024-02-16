require_relative 'methods'

class Train
  include Producer
  include InstanceCounter

  attr_reader :number, :carriages, :route
  attr_accessor :speed

  def self.find(number)
    all.detect { |train| train.number == number }
  end

  def initialize(number)
    @number = number
    @carriages = []
    @speed = 0
    @route = nil
    @station = nil
    register_instance(self)
  end

  def stop
    # остановить поезд
    self.speed = 0
  end

  def length
    carriages.length
  end

  def attach(carriage)
    # прицепить вагон
    if (speed == 0)
      if type == carriage.type
        carriages << carriage
      else
        puts "Неверный тип вагона"
      end
    else
      puts "Нельзя прицеплять вагоны на ходу"
    end
    return length
  end

  def unattach(carriage)
    # отцепить вагон
    if (speed == 0)
      carriages.delete(carriage)
    else
      puts "Нельзя отцеплять вагоны на ходу"
    end
    return length
  end

  def set_route(route)
    self.route = route
    self.station = route.first
    route.first.take(self)
  end

  def station_current
    station
  end

  def station_next
    return nil if route.nil?
    route.next(station)
  end

  def station_prev
    return nil if route.nil?
    route.prev(station)
  end

  def go_ahead
    # пока поезд перемещается мгновенно
    if !route.last?(station)
      station.send(self)
      self.station = station_next
      station.take(self)
      return station
    end
    # уже конечная станция
    return nil
  end

  def go_back
    # пока поезд перемещается мгновенно
    if !route.first?(station)
      station.send(self)
      self.station = station_prev
      station.take(self)
      return station
    end
    # уже конечная станция
    return nil
  end

  def type
  end

  def type_to_s
    return type == :cargo ? "грузовой" : "пассажирский" if type
  end

  def to_s
    return "#{self.type_to_s} поезд №#{number} (#{get_numeric(self.length, ['вагон', 'вагона', 'вагонов'])})"
  end

  protected

  # доспуп только для потомков, для остальных доступ через спец. методы
  attr_accessor :station
  attr_writer :route

end