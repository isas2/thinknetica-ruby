require_relative 'methods'

class Train
  attr_reader :number, :type, :length
  attr_accessor :speed

  def initialize(number, type, length)
    @number = number
    @type = type
    @length = length
    @speed = 0
    @route = nil
    @stantion = nil
  end

  def stop
    # остановить поезд
    self.speed = 0
  end

  def attach
    # прицепить вагон
    if (@speed == 0)
      @length += 1
    else
      puts "Нельзя прицеплять вагоны на ходу"
    end
    return @length
  end

  def unattach
    # отцепить вагон
    if (speed == 0)
      @length -= 1
    else
      puts "Нельзя отцеплять вагоны на ходу"
    end
    return @length
  end

  def route(route)
    @route = route
    @stantion = route.first
  end

  def stantion_current
    @stantion
  end

  def stantion_next
    return nil if @route.nil?
    @route.next(@stantion)
  end

  def stantion_prev
    return nil if @route.nil?
    @route.prev(@stantion)
  end

  def go_ahead
    # пока поезд перемещается мгновенно
    if !@route.last?(@stantion)
      @stantion.send(self)
      @stantion = self.stantion_next
      @stantion.take(self)
      return @stantion
    end
    # уже конечная станция
    return nil
  end

  def go_back
    # пока поезд перемещается мгновенно
    if !@route.first?(@stantion)
      @stantion.send(self)
      @stantion = self.stantion_prev
      @stantion.take(self)
      return @stantion
    end
    # уже конечная станция
    return nil
  end

  def type_to_s
    return @type == :cargo ? "грузовой" : "пассажирский"
  end

  def to_s
    return "#{self.type_to_s} поезд №#{@number} (#{get_numeric(@length, ['вагон', 'вагона', 'вагонов'])})"
  end

end