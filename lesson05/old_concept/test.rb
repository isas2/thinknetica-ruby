=begin
Тестирование работы объектов.
=end

require_relative 'lib/producer'
require_relative 'lib/instance_counter'
require_relative 'lib/train'
require_relative 'lib/carriage'
Dir['lib/*.rb'].each { |file| require_relative file }

# тест станции
station = Station.new('Новая')
train1 = CargoTrain.new('28А')
43.times { |i| train1.attach(CargoCarriage.new("ВА01#{i}"))}
train2 = PassangerTrain.new('602Ч')
12.times { |i| train2.attach(PassangerCarriage.new("ТА032#{i}"))}
train3 = CargoTrain.new('123А')
55.times { |i| train3.attach(CargoCarriage.new("ВБ02#{i}"))}
train4 = PassangerTrain.new('107С')
10.times { |i| train4.attach(PassangerCarriage.new("ТД037#{i}"))}
[train1, train2, train3, train4].each do |train|
  station.take(train)
end
puts "Поиск поезда 123А: '#{Train.find('123А')}'"

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
train1.set_route(route2)
while train1.go_ahead do
end

puts
puts "Trains: #{Train.instances}"
puts "PassangerTrain: #{PassangerTrain.instances}"
puts "CargoTrain: #{CargoTrain.instances}"
puts "Routes: #{Route.instances}"
puts "Station: #{Station.instances}"
