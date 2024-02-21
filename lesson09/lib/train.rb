# frozen_string_literal: true

require_relative 'methods'

class Train
  include Vehicle
  include InstanceCounter
  include Validation
  include Accessors

  attr_reader :number, :carriages, :route, :type

  strong_attr_accessor :speed, Integer
  validate :number,  :presence
  validate :number,  :type,    String
  validate :number,  :format,  /^[а-я\d]{3}-*[а-я\d]{2}$/i
  validate :station, :type,    Station

  def self.find(number)
    all.detect { |train| train.number == number }
  end

  def initialize(number)
    @number = number
    raise 'Номер поезда несоответствует устновленному формату.' unless valid?

    @carriages = []
    @speed = 0
    @route = nil
    @station = nil
    register_instance(self)
  end

  def do_with_carriages(&block)
    @carriages.each_with_index { |carriage, index| block.call(carriage, index) }
  end

  def stop
    self.speed = 0
  end

  def length
    carriages.length
  end

  def attach(carriage)
    # прицепить вагон
    raise 'Неверный тип вагона' if type != carriage.type
    raise 'Нельзя прицеплять вагоны на ходу' if speed != 0

    carriages << carriage
    length
  end

  def unattach(carriage)
    # отцепить вагон
    raise 'Нельзя отцеплять вагоны на ходу' if speed != 0

    carriages.delete(carriage)
    length
  end

  def route=(route)
    @route = route
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
    raise 'Поезду не назначен маршрут' if route.nil?
    raise 'Поезд уже на конечной станции маршрута' if route.last?(station)

    result = station.send(self)
    self.station = station_next
    "#{result}\n#{station.take(self)}"
  end

  def go_back
    # пока поезд перемещается мгновенно
    raise 'Поезду не назначен маршрут' if route.nil?
    raise 'Поезд уже на начальной станции маршрута' if route.first?(station)

    result = station.send(self)
    self.station = station_prev
    "#{result}\n#{station.take(self)}"
  end

  def to_s
    "#{Train.types[type]} поезд №#{number} (#{get_numeric(length, %w[вагон вагона вагонов])})"
  end

  protected

  attr_accessor :station
end
