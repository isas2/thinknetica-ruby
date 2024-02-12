=begin
Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя). 
Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным. 
(Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?)
=end

def leap?(year)
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
end

months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

print "Введите число: "
d = gets.chomp.to_i
print "Введите месяц: "
m = gets.chomp.to_i
print "Введите год: "
y = gets.chomp.to_i
# Проверки корректности ввода по условию задачи нет

yday = d
month = 1
while month < m do
    yday += months[month - 1]
    month += 1
end

yday += 1 if leap?(y) && m > 2
puts "Порядковый номер даты: #{yday}"