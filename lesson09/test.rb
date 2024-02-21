# frozen_string_literal: true

# Тестирование работы объектов.

require_relative 'lib/instance_counter'
require_relative 'lib/accessors'
require_relative 'lib/validation'
require_relative 'lib/vehicle'
require_relative 'lib/station'
require_relative 'lib/route'
require_relative 'lib/train'
require_relative 'lib/carriage'
Dir['lib/*.rb'].sort.each { |file| require_relative file }

# puts Train.types.inspect
# тест станции
station = Station.new('Новая')
puts "Валидация объекта станции: #{station.valid?}"
train1 = CargoTrain.new('28Ч-02')
43.times { |_i| train1.attach(CargoCarriage.new(Carriage.random_number)) }
train2 = PassangerTrain.new('602-ЧН')
12.times { |_i| train2.attach(PassangerCarriage.new(Carriage.random_number)) }
train3 = CargoTrain.new('123-АП')
55.times { |_i| train3.attach(CargoCarriage.new(Carriage.random_number)) }
train4 = PassangerTrain.new('107СН')
10.times { |_i| train4.attach(PassangerCarriage.new(Carriage.random_number)) }
[train1, train2, train3, train4].each do |train|
  station.take(train)
end
puts "Поиск поезда 123-АП: '#{Train.find('123-АП')}'"
puts "Валидация объекта поезда: #{train1.valid?}"

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
puts "Маршрут #{route1.info}"
route2 = Route.new(Station.new('Чита'), Station.new('Краснокаменск'))
route2.add(Station.new('Карымская'))
route2.add(Station.new('Могойтуй'))
route2.add(Station.new('Оловянная'))
route2.add(Station.new('Борзя'))
puts "Маршрут #{route2.info}"
puts route2.list

# тест движения поезда по маршруту
puts
train1.route = route2
loop do
  puts train1.go_ahead
rescue RuntimeError => e
  puts "Ошибка! #{e.message}"
  break
end

puts
puts "Trains: #{Train.instances}"
puts "PassangerTrain: #{PassangerTrain.instances}"
puts "CargoTrain: #{CargoTrain.instances}"
puts "Routes: #{Route.instances}"
puts "Station: #{Station.instances}"
