=begin
Идеальный вес. 
рограмма запрашивает у пользователя имя и рост и выводит идеальный вес по формуле (<рост> - 110) * 1.15,
после чего выводит результат пользователю на экран с обращением по имени. 
Если идеальный вес получается отрицательным, то выводится строка "Ваш вес уже оптимальный" 
=end

print "Введите Ваше имя: "
name = gets.chomp

print "Введите Ваш рост, см: "
height = gets.chomp.to_i

result = (height - 110) * 1.15
if result < 0
    puts "#{name}, Ваш вес уже оптимальный"
else
    puts "#{name}, Ваш идеальный вес: #{result}кг"
end