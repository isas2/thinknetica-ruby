=begin
Тестирование работы объектов.
=end

require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'methods'

# тест станции
station = Station.new('Новая')
station.take(Train.new('28А', :cargo, 43))
station.take(Train.new('602Ч', :passenger, 12))
station.take(Train.new('123А', :cargo, 55))
station.take(Train.new('107С', :passenger, 10))

# тест отправления поезда
puts "\nПассажирские поезда на станции:"
station.trains_by_type(:passenger).each do |train|
  puts upcase_first(train.to_s)
  station.send(train)
end

# тест вывода списка поездов
puts "\nСписок всех поездов на станции:"
station.trains.each { |train| puts upcase_first(train.to_s) }

# тест создания маршрутов
puts
route1 = Route.new(Station.new('Новосибирск'), Station.new('Бердск'))
puts "Маршрут #{route1}"
route2 = Route.new(Station.new('Чита'), Station.new('Краснокаменск'))
route2.add(Station.new('Карымская'))
route2.add(Station.new('Могойтуй'))
route2.add(Station.new('Оловянная'))
route2.add(Station.new('Борзя'))
puts "Маршрут #{route2}"
puts route2.list

# тест движения поезда по маршруту
puts
train = Train.new('622Ч', :passenger, 14)
train.route(route2)
while train.go_ahead do
end