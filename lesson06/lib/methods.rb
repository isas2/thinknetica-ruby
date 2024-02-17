def get_numeric(number, words)
  if number.between?(10, 20)
    return "#{number} #{words[2]}"
  end
  case number % 10
    when 1
      return "#{number} #{words[0]}"
    when 2..4
      return "#{number} #{words[1]}"
    when 0, 5..9
      return "#{number} #{words[2]}"
  end
end

def upcase_first(string)
  string[0] = string[0].upcase
  string
end

def init_data
  # создадим несколько станций
  names = ['Чита', 'Новая', 'Дарасун', 'Ага', 'Могойтуй', 'Ясная', 'Борзя', 'Забайкальск']
  names.each { |name| Station.new(name) }
  # создадим пару поездов
  train1 = CargoTrain.new('28А-ТТ')
  23.times { |i| train1.attach(CargoCarriage.new(Carriage.random_number))}
  train2 = PassangerTrain.new('602ЧБ')
  12.times { |i| train2.attach(PassangerCarriage.new(Carriage.random_number))}
  # создадим новый маршрут
  route = Route.new(Station.all[0], Station.all[-1])
  route.add(Station.all[4])
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

def show_station_trains
  station = get_station
  if station 
    show_objects(station.trains, "поездов на станции #{station}")
  end
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
    carriage = train.type == :cargo ? CargoCarriage.new(number) : PassangerCarriage.new(number)
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