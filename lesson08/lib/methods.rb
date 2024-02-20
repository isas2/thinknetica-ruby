# frozen_string_literal: true

def get_numeric(amount, words)
  return "#{amount} #{words[2]}" if amount.between?(10, 20)

  case amount % 10
  when 1
    "#{amount} #{words[0]}"
  when 2..4
    "#{amount} #{words[1]}"
  when 0, 5..9
    "#{amount} #{words[2]}"
  end
end

def upcase_first(string)
  string[0] = string[0].upcase if string[0] != string[0].upcase
  string
end

def init_data
  names = %w[Чита Новая Маккавеево Дарасун Карымская Ага Могойтуй Ясная Борзя Забайкальск]
  names.each { |name| Station.new(name) }
  init_trains
  init_routes
end

def random_carriage(type)
  if type == :cargo
    CargoCarriage.new(Carriage.random_number, [77, 88, 132, 138].sample)
  else
    PassangerCarriage.new(Carriage.random_number, [16, 18, 54, 81, 105].sample)
  end
end

def init_trains
  %w[28А-ТТ 340-ТА].each { |name| CargoTrain.new(name) }
  %w[026ПБ 601ЧА].each { |name| PassangerTrain.new(name) }
  train_lengths = [rand(20..30), rand(20..30), rand(4..8), rand(8..16)]
  train_lengths.each.with_index do |len, i|
    len.times { |_i| Train.all[i].attach(random_carriage(Train.all[i].type)) }
  end
end

def init_routes
  route1 = Route.new(Station.all[0], Station.all[-1])
  Station.all[1..-2].each { |st| route1.add(st) }
  route2 = Route.new(Station.all[4], Station.all[0])
  Station.all[1..3].reverse_each { |st| route2.add(st) }
  routes = [route1, route1, route2, route1]
  Train.all.each_with_index { |t, i| t.route = routes[i] }
end

def run(func)
  # запускает нужную функцию
  system('clear') || system('cls')
  method(func).call
  puts "\nНажмите клавишу Enter..."
  gets
end

def show_objects(list, title)
  # выводит нумерованный список объектов
  if list.length.positive?
    puts "Список #{title}:"
    list.each_with_index { |o, i| puts "#{i + 1}. #{upcase_first(o.to_s)}" }
  else
    puts "Список #{title} пуст"
  end
end

def show_stations
  show_objects(Station.all, 'станций')
end

def show_route_stations(route)
  show_objects(route.stations, 'станций')
end

def show_trains
  show_objects(Train.all, 'поездов')
end

def show_carriages(train)
  show_objects(train.carriages, "вагонов поезда #{train.number}")
end

def show_routes
  show_objects(Route.all, 'маршрутов')
end

def show_station_trains
  station = select_station
  return unless station

  puts "Список поездов на станции #{station.name}:"
  # старая реализация вывода
  # show_objects(station.trains, "поездов на станции #{station}")
  # вывод используя передачу блока
  station.do_with_trains { |t, i| puts "#{i + 1}. #{t.number}, #{Train.types[t.type]}, вагонов: #{t.length}" }
end

def show_train_carriages
  train = select_train
  return unless train

  puts "Список вагонов поезда #{train.number}:"
  # вывод используя передачу блока
  train.do_with_carriages do |c, i|
    puts "#{i + 1}. #{c.number}, #{Carriage.types[c.type]}, свободно: #{c.free_volume}, занято: #{c.volume}"
  end
end

def select_object(list, title)
  return unless list.length.positive?

  index = 0
  loop do
    show_objects(list, title[1])
    puts "\nВыбран неверный порядковый номер #{title[0]}. Повторите ввод (число от 1 до #{list.length}):"
    index = gets.chomp.strip.to_i
    puts
    return list[index - 1] if index.between?(1, list.length)
  end
end

def select_station
  select_object(Station.all, %w[станции станций])
end

def select_train
  select_object(Train.all, %w[поезда поездов])
end

def select_train_type
  select_object(Train.types.values.map(&:capitalize), ['типа поезда', 'типов поездов'])
end

def select_route
  select_object(Route.all, %w[маршрута маршрутов])
end

def select_carriage(train)
  select_object(train.carriages, ['вагона', "вагонов поезда #{train.number}"])
end

def select_route_station(route)
  select_object(route.stations, %w[станции станций])
end

def new_station
  puts "Создание новой ЖД станций.\n"
  loop do
    print "\nВведите назнание новой станции: "
    name = gets.chomp
    begin
      Station.new(name)
      puts "Создана новая станция: #{name}"
      break
    rescue RuntimeError => e
      puts "Ошибка! #{e.message}"
    end
  end
end

def new_train
  puts "Создание нового поезда.\n\n"
  type = Train.types.key(select_train_type.downcase)
  loop do
    print 'Введите номер поезда: '
    number = gets.chomp
    begin
      train = type == :cargo ? CargoTrain.new(number) : PassangerTrain.new(number)
      puts "\nСоздан новый поезд: #{train}"
      break
    rescue RuntimeError => e
      puts "Ошибка! #{e.message}"
    end
  end
end

def new_carriage
  train = select_train
  return unless train

  carriage = new_carriage_by_type(train)
  begin
    train.attach(carriage)
    puts "К поезду #{train.number} прицеплен новый вагон #{carriage.number}"
  rescue RuntimeError => e
    puts "Ошибка! #{e.message}"
  end
end

def new_carriage_by_type(train)
  number = Carriage.random_number
  loop do
    print 'Введите вместимость вагона (1..150): '
    capacity = gets.chomp.to_i
    begin
      return CargoCarriage.new(number, capacity) if train.type == :cargo

      return PassangerCarriage.new(number, capacity)
    rescue RuntimeError => e
      puts "Ошибка! #{e.message}"
    end
  end
end

def delete_carriage
  train = select_train
  return unless train

  carriage = select_carriage(train)
  return unless carriage

  begin
    train.unattach(carriage)
    puts "От поезда #{train.number} отцеплен вагон #{carriage.number}"
  rescue RuntimeError => e
    puts "Ошибка! #{e.message}"
  end
end

def load_carriage
  train = select_train
  return unless train

  carriage = select_carriage(train)
  return unless carriage

  title = carriage.type == :cargo ? 'объём груза' : 'количество пассажиров'
  loop do
    print "Введите #{title}: "
    volume = gets.chomp.to_i
    begin
      load_carriage_by_type(carriage, volume)
      break
    rescue RuntimeError => e
      puts "Ошибка! #{e.message}"
    end
  end
end

def load_carriage_by_type(carriage, volume)
  if carriage.type == :cargo
    carriage.add_cargo(volume)
    puts "Груз, объёмом #{volume} успешно погружен в вагон #{carriage.number}"
  else
    volume.times do |i|
      carriage.add_passenger
      puts "Пассажир #{i + 1} успешно произвёл посадку в вагон #{carriage.number}"
    end
  end
end

def new_route
  puts "Создание нового маршрута:\n"
  puts 'Укажите станцию отправления.'
  first = select_station
  puts 'Укажите станцию назначения.'
  last = select_station
  return unless first && last

  route = Route.new(first, last)
  puts "Создан новый маршрут: #{route}"
end

def show_route_info
  route = select_route
  return unless route

  show_route_stations(route)
end

def add_route_station
  route = select_route
  return unless route

  station = select_station
  # можно проверить есть ли выбранная станция в маршруте
  return unless station

  route.add(station)
  puts "В маршрут следования #{route} добавлена станция #{station}"
end

def delete_route_station
  route = select_route
  return unless route

  station = select_route_station(route)
  return unless station

  route.delete(station)
  puts "Из маршрута следования #{route} удалена станция #{station}"
end

def set_train_route
  train = select_train
  return unless train

  route = select_route
  return unless route

  puts "Поезду #{train.number} назначен маршрут #{route}"
  train.set_route(route)
end

def go_train_ahead
  train = select_train
  return unless train

  begin
    puts train.go_ahead
  rescue RuntimeError => e
    puts "Ошибка! #{e.message}"
  end
end

def go_train_back
  train = select_train
  return unless train

  begin
    puts train.go_back
  rescue RuntimeError => e
    puts "Ошибка! #{e.message}"
  end
end
