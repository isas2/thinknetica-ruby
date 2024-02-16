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

  def info
    "#{stations[0].name} - #{stations[-1].name}"
  end

  def to_s
    # описание маршрута
    if stations.length == 2
      return "#{info} (экспресс, без промежуточных остановок)"
    else
      names = stations.slice(1, stations.length - 2).map { |st| st.name }
      return "#{info} (c промежуточными станциями #{names.join(', ')})"
    end
  end

  def list
    # возвращает строку - список всех станций
    (stations.map { |st| st.name }).join(', ')
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
    return nil if self.last?(station)
    return stations[stations.find_index(station) + 1]
  end

  def prev(station)
    return nil if self.first?(station)
    return stations[stations.find_index(station) - 1]
  end

end