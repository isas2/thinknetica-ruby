class Route
  attr_reader :stantions

  def initialize(first, last)
    @stantions = [first, last]
  end

  def add(stantion)
    # добавляет станцию на предпоследнюю позицию маршрута
    stantions.insert(-2, stantion)
  end

  def delete(stantion)
    # удаляет станцию
    stantions.delete(stantion)
  end

  def info
    "#{stantions[0].name} - #{stantions[-1].name}"
  end

  def to_s
    # описание маршрута
    if stantions.length == 2
      return "#{info} (экспресс, без промежуточных остановок)"
    else
      names = stantions.slice(1, stantions.length - 2).map { |st| st.name }
      return "#{info} (c промежуточными станциями #{names.join(', ')})"
    end
  end

  def list
    # возвращает строку - список всех станций
    (stantions.map { |st| st.name }).join(', ')
  end

  def first
    stantions[0]
  end

  def first?(stantion)
    stantions[0] == stantion
  end

  def last
    stantions[-1]
  end

  def last?(stantion)
    stantions[-1] == stantion
  end

  def next(stantion)
    return nil if self.last?(stantion)
    return stantions[stantions.find_index(stantion) + 1]
  end

  def prev(stantion)
    return nil if self.first?(stantion)
    return stantions[stantions.find_index(stantion) - 1]
  end

end