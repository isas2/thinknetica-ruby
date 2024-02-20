# frozen_string_literal: true

class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(first, last)
    @stations = [first, last]
    register_instance(self)
  end

  def add(station)
    # добавляет станцию на предпоследнюю позицию маршрута
    stations.insert(-2, station)
  end

  def delete(station)
    # удаляет станцию
    stations.delete(station)
  end

  def to_s
    "#{stations[0].name} - #{stations[-1].name}"
  end

  def info
    # описание маршрута
    if stations.length == 2
      "#{self} (экспресс, без промежуточных остановок)"
    else
      names = stations.slice(1, stations.length - 2).map(&:name)
      "#{self} (c промежуточными станциями #{names.join(', ')})"
    end
  end

  def list
    # возвращает строку - список всех станций
    stations.map(&:name).join(', ')
  end

  def first
    stations[0]
  end

  def first?(station)
    stations[0] == station
  end

  def last
    stations[-1]
  end

  def last?(station)
    stations[-1] == station
  end

  def next(station)
    return nil if last?(station)

    stations[stations.find_index(station) + 1]
  end

  def prev(station)
    return nil if first?(station)

    stations[stations.find_index(station) - 1]
  end
end
