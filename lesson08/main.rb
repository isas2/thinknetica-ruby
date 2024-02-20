# frozen_string_literal: true

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
      sub_menu.item('Список станций') { run(:show_stations) }
      sub_menu.item('Добавить станцию') { run(:new_station) }
      sub_menu.item('Список поездов на станции') { run(:show_station_trains) }
      sub_menu.item '----------------------'
      sub_menu.item('Назад (в главное меню)') { :menu_exit }
    end
  end
  menu.item 'Маршруты' do
    CursesMenu.new 'Управление маршрутами движения' do |sub_menu|
      sub_menu.item('Список маршрутов') { run(:show_routes) }
      sub_menu.item('Создать новый маршрут') { run(:new_route) }
      sub_menu.item('Добавить в маршрут станцию') { run(:add_route_station) }
      sub_menu.item('Удалить из маршрута станцию') { run(:delete_route_station) }
      sub_menu.item('Просмотр маршрута') { run(:show_route_info) }
      sub_menu.item '----------------------'
      sub_menu.item('Назад (в главное меню)') { :menu_exit }
    end
  end
  menu.item 'Поезда' do
    CursesMenu.new 'Управление поездами' do |sub_menu|
      sub_menu.item('Список поездов') { run(:show_trains) }
      sub_menu.item('Создать поезд') { run(:new_train) }
      sub_menu.item '----------------------'
      sub_menu.item('Назначать поезду маршрут') { run(:set_train_route) }
      sub_menu.item('Переместить поезд по маршруту вперед') { run(:go_train_ahead) }
      sub_menu.item('Переместить поезд по маршруту назад') { run(:go_train_back) }
      sub_menu.item '----------------------'
      sub_menu.item('Назад (в главное меню)') { :menu_exit }
    end
  end
  menu.item 'Вагоны' do
    CursesMenu.new 'Управление вагонами' do |sub_menu|
      sub_menu.item('Список вагонов поезда') { run(:show_train_carriages) }
      sub_menu.item('Прицепить вагон к поезду') { run(:new_carriage) }
      sub_menu.item('Отцепить вагон от поезда') { run(:delete_carriage) }
      sub_menu.item('Загрузка вагона / посадка пассажиров') { run(:load_carriage) }
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
