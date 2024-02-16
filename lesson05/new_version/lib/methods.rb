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
  train1 = CargoTrain.new('28А')
  23.times { |i| train1.attach(CargoCarriage.new("ВА01#{i}"))}
  train2 = PassangerTrain.new('602Ч')
  12.times { |i| train2.attach(PassangerCarriage.new("ТА032#{i}"))}
  # создадим новый маршрут
  route = Route.new(Station.all[0], Station.all[-1])
  route.add(Station.all[4])
  @routers << route
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
  show_objects(@routers, 'маршрутов')
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

def get_route
  get_object(@routers, ['маршрута', 'маршрутов'])
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
  puts "Создание новой станций:\n"
  print "Введите назнание новой станции: "
  name = gets.chomp
  while name.length == 0
    puts "\nНазвание станции не может быть пустым! Повторите ввод."
    print "Введите назнание новой станции: "
    name = gets.chomp
  end
  Station.new(name)
  puts "Создана новая станция: #{name}"
end

def new_train
  puts "Создание нового поезда:\n"
  print "Введите номер поезда: "
  number = gets.chomp
  while number.length == 0
    puts "\nНомер поезда не может быть пустым! Повторите ввод."
    print "Введите номер поезда: "
    number = gets.chomp
  end
  puts "Выберите тип поезда: \n1. Пассажирский \n2. Грузовой"
  type = gets.chomp
  while !['1', '2'].include?(type)
    puts "Выбран неверный тип поезда. Повторите ввод: \n1. Пассажирский \n2. Грузовой"
    type = gets.chomp
  end
  train = type == '1' ? PassangerTrain.new(number) : CargoTrain.new(number)
  puts "Создан новый поезд: #{train}"
end

def new_carriage
  train = get_train
  if train
    number = ('A'..'H').to_a.shuffle[0, 2].join + ('0'..'9').to_a.shuffle[0, 5].join
    carriage = train.type == :cargo ? CargoCarriage.new(number) : PassangerCarriage.new(number)
    train.attach(carriage)
    puts "К поезду #{train.number} прицеплен новый вагон #{carriage.number}" 
  end
end

def delete_carriage
  train = get_train
  if train 
    carriage = get_carriage(train)
    if carriage
      train.unattach(carriage)
      puts "От поезда #{train.number} отцеплен вагон #{carriage.number}" 
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
    @routers << route
    puts "Создан новый маршрут: #{route.info}"
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
      puts "В маршрут следования #{route.info} добавлена станция #{station}" 
    end
  end
end

def delete_route_station
  route = get_route
  if route 
    station = get_route_station(route)
    if station 
      route.delete(station)
      puts "Из маршрута следования #{route.info} удалена станция #{station}" 
    end
  end
end

def set_train_route
  train = get_train
  if train 
    route = get_route
    if route
      puts "Поезду #{train.number} назначен маршрут #{route.info}"
      train.set_route(route)
    end
  end
end

def go_train_ahead
  train = get_train
  if train 
    if train.route
      puts "Ошибка! Поезд уже на конечной станции маршрута" if !train.go_ahead
    else
      puts "Ошибка! Поезду #{train.number} не назначен маршрут"
    end
  end
end

def go_train_back
  train = get_train
  if train 
    if train.route
      puts "Ошибка! Поезд уже на начальной станции маршрута" if !train.go_back
    else
      puts "Ошибка! Поезду #{train.number} не назначен маршрут"
    end
  end
end