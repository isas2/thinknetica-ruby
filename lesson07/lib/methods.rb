def get_numeric(amount, words)
  if amount.between?(10, 20)
    return "#{amount} #{words[2]}"
  end
  case amount % 10
    when 1
      return "#{amount} #{words[0]}"
    when 2..4
      return "#{amount} #{words[1]}"
    when 0, 5..9
      return "#{amount} #{words[2]}"
  end
end

def get_сarriage_num(amount)
  get_numeric(self.length, ['вагон', 'вагона', 'вагонов'])
end

def upcase_first(string)
  string[0] = string[0].upcase
  string
end

def init_data
  # создадим несколько станций
  names = ['Чита', 'Новая', 'Маккавеево', 'Дарасун', 'Карымская', 'Ага', 'Могойтуй', 'Ясная', 'Борзя', 'Забайкальск']
  names.each { |name| Station.new(name) }
  # сформируем поезда
  train1 = CargoTrain.new('28А-ТТ')
  rand(20..30).times { |i| train1.attach(CargoCarriage.new(Carriage.random_number, [77, 88, 132, 138].sample))}
  train2 = CargoTrain.new('340-ТА')
  rand(20..30).times { |i| train2.attach(CargoCarriage.new(Carriage.random_number, [77, 88, 132, 138].sample))}
  train3 = PassangerTrain.new('026ПБ')
  rand(4..8).times { |i| train3.attach(PassangerCarriage.new(Carriage.random_number, [54, 81, 105].sample))}
  train4 = PassangerTrain.new('601ЧА')
  rand(8..16).times { |i| train4.attach(PassangerCarriage.new(Carriage.random_number, [16, 18, 36, 54, 81].sample))}
  # создадим маршруты, назначим поездам
  route1 = Route.new(Station.all[0], Station.all[-1])
  Station.all[1..-2].each { |st| route1.add(st) }
  route2 = Route.new(Station.all[4], Station.all[0])
  Station.all[1..3].reverse_each { |st| route2.add(st) }
  train1.set_route(route1)
  train2.set_route(route1)
  train3.set_route(route2)
  train4.set_route(route1)
end

def run(func)
  # запускает нужную функцию
  system("clear") || system("cls")
  method(func).call
  puts "\nНажмите клавишу Enter..."
  gets
end
 
def show_objects(list, title)
  # выводит нумерованный список объектов
  if list.length > 0
    puts "Список #{title}:"
    list.each_with_index { |o, i| puts "#{i + 1}. #{upcase_first(o.to_s)}"}
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
  station = get_station
  if station
    puts "Список поездов на станции #{station.name}:"
    # старая реализация вывода
    # show_objects(station.trains, "поездов на станции #{station}")
    # вывод используя передачу блока
    station.do_with_trains { |t, i| puts "#{i+1}. #{t.number}, #{Train.types[t.type]}, вагонов: #{t.length}"}
  end
end

def show_train_carriages
  train = get_train
  if train 
    puts "Список вагонов поезда #{train.number}:"
    # вывод используя передачу блока
    train.do_with_carriages { |c, i| puts "#{i+1}. #{c.number}, #{Carriage.types[c.type]}, свободно: #{c.free_volume}, занято: #{c.volume}"}
  end
end

def get_object(list, title)
  # возвращает объект из списка по его номеру
  show_objects(list, title[1])
  if list.length > 0
    puts "\nВыберите порядковый номер #{title[0]} (число от 1 до #{list.length}):"
    index = gets.chomp.strip.to_i
    while !index.between?(1, list.length)
      show_objects(list, title[1])
      puts "\nВыбран неверный порядковый номер #{title[0]}. Повторите ввод (число от 1 до #{list.length}):"
      index = gets.chomp.strip.to_i
    end
    puts
    list[index - 1]
  end
end

def get_station
  get_object(Station.all, ['станции', 'станций'])
end

def get_train
  get_object(Train.all, ['поезда', 'поездов'])
end

def get_train_type
  get_object(Train.types.values.map { |t| t.capitalize }, ['типа поезда', 'типов поездов'])
end

def get_route
  get_object(Route.all, ['маршрута', 'маршрутов'])
end

def get_carriage(train)
  get_object(train.carriages, ['вагона', "вагонов поезда #{train.number}"])
end

def get_route_station(route)
  get_object(route.stations, ['станции', 'станций'])
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
  type = Train.types.key(get_train_type.downcase)
  loop do
    print "Введите номер поезда: "
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
  train = get_train
  if train
    number = Carriage.random_number
    carriage = nil
    loop do
      print "Введите вместимость вагона (1..150): "
      capacity = gets.chomp.to_i
      begin
        carriage = train.type == :cargo ? CargoCarriage.new(number, capacity) : PassangerCarriage.new(number, capacity)
        break
      rescue RuntimeError => e
        puts "Ошибка! #{e.message}"
      end   
    end
    begin
      train.attach(carriage)
      puts "К поезду #{train.number} прицеплен новый вагон #{carriage.number}"
    rescue RuntimeError => e
      puts "Ошибка! #{e.message}"
    end
  end
end

def delete_carriage
  train = get_train
  if train 
    carriage = get_carriage(train)
    if carriage
      begin
        train.unattach(carriage)
        puts "От поезда #{train.number} отцеплен вагон #{carriage.number}" 
      rescue RuntimeError => e
        puts "Ошибка! #{e.message}"
      end
    end
  end
end

def load_carriage
  train = get_train
  if train
    carriage = get_carriage(train)
    if carriage
      title = carriage.type == :cargo ? "объём груза" : "количество пассажиров"
      loop do
        print "Введите #{title}: "
        volume = gets.chomp.to_i
        begin
          if carriage.type == :cargo
            carriage.add_cargo(volume)
            puts "Груз, объёмом #{volume} успешно погружен в вагон #{carriage.number}"
          else
            volume.times do |i| 
              carriage.add_passenger
              puts "Пассажир #{i + 1} успешно произвёл посадку в вагон #{carriage.number}"
            end
          end
          break
        rescue RuntimeError => e
          puts "Ошибка! #{e.message}"
        end
      end
    end
  end
end

def new_route
  puts "Создание нового маршрута:\n"
  puts "Укажите станцию отправления."
  first = get_station
  puts "Укажите станцию назначения."
  last = get_station
  if first && last
    route = Route.new(first, last)
    puts "Создан новый маршрут: #{route}"
  end
end

def show_route_info
  route = get_route
  if route 
    show_route_stations(route)
  end
end

def add_route_station
  route = get_route
  if route 
    station = get_station
    # можно проверить есть ли выбранная станция в маршруте
    if station 
      route.add(station)
      puts "В маршрут следования #{route} добавлена станция #{station}" 
    end
  end
end

def delete_route_station
  route = get_route
  if route 
    station = get_route_station(route)
    if station 
      route.delete(station)
      puts "Из маршрута следования #{route} удалена станция #{station}" 
    end
  end
end

def set_train_route
  train = get_train
  if train 
    route = get_route
    if route
      puts "Поезду #{train.number} назначен маршрут #{route}"
      train.set_route(route)
    end
  end
end

def go_train_ahead
  train = get_train
  if train 
    begin
      puts train.go_ahead
    rescue RuntimeError => e
      puts "Ошибка! #{e.message}"
    end
  end
end

def go_train_back
  train = get_train
  if train 
    begin
      puts train.go_back
    rescue RuntimeError => e
      puts "Ошибка! #{e.message}"
    end
  end
end