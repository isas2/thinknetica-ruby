require 'curses_menu'
require_relative 'lib/instance_counter'
require_relative 'lib/vehicle'
require_relative 'lib/train'
require_relative 'lib/carriage'
Dir['lib/*.rb'].each { |file| require_relative file }

# немного тестовых данных
init_data

CursesMenu.new 'Главное управление железной дороги' do |menu|
  menu.item 'Станции' do
    CursesMenu.new 'Управление станциями' do |sub_menu|
      sub_menu.item 'Список станций' do run(:show_stations) end
      sub_menu.item 'Добавить станцию' do run(:new_station) end
      sub_menu.item 'Список поездов на станции' do run(:show_station_trains) end
      sub_menu.item '----------------------'
      sub_menu.item('Назад (в главное меню)') { :menu_exit }
    end
  end
  menu.item 'Поезда' do
    CursesMenu.new 'Управление поездами' do |sub_menu|
      sub_menu.item 'Список поездов' do run(:show_trains) end
      sub_menu.item 'Создать поезд' do run(:new_train) end
      sub_menu.item 'Прицепить вагон к поезду' do run(:new_carriage) end
      sub_menu.item 'Отцепить вагон от поезда' do run(:delete_carriage) end
      sub_menu.item '----------------------'
      sub_menu.item 'Назначать поезду маршрут' do run(:set_train_route) end
      sub_menu.item 'Переместить поезд по маршруту вперед' do run(:go_train_ahead) end
      sub_menu.item 'Переместить поезд по маршруту назад' do run(:go_train_back) end
      sub_menu.item '----------------------'
      sub_menu.item('Назад (в главное меню)') { :menu_exit }
    end
  end
  menu.item 'Маршруты' do
    CursesMenu.new 'Управление маршрутами движения' do |sub_menu|
      sub_menu.item 'Список маршрутов' do run(:show_routes) end
      sub_menu.item 'Создать новый маршрут' do run(:new_route) end
      sub_menu.item 'Добавить в маршрут станцию' do run(:add_route_station) end
      sub_menu.item 'Удалить из маршрута станцию' do run(:delete_route_station) end
      sub_menu.item 'Просмотр маршрута' do run(:show_route_info) end
      sub_menu.item '----------------------'
      sub_menu.item('Назад (в главное меню)') { :menu_exit }
    end
  end
  menu.item '-----'
  menu.item 'Выход' do
    puts 'Выход...'
    :menu_exit
  end
end



 