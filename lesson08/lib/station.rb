# frozen_string_literal: true

class Station
  include InstanceCounter

  NAME_FORMAT = /^[а-я\d]{1}[а-я \d-]{1,48}[а-я\d]{1}$/i.freeze

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    raise 'Название станции несоответствует устновленному формату.' unless valid?

    @trains = []
    register_instance(self)
  end

  def do_with_trains(&block)
    @trains.each_with_index { |train, index| block.call(train, index) }
  end

  def valid?
    (@name =~ NAME_FORMAT) != nil
  end

  def take(train)
    # принять поезд на станции
    trains << train
    "Внимание! На станцию #{name} прибыл #{train}"
  end

  def send(train)
    # отправить поезд со станции
    trains.delete(train)
    "Внимание! Со станции #{name} отправляется #{train}"
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end

  def to_s
    name
  end
end
