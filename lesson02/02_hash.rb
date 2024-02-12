=begin
Заполнить массив числами от 10 до 100 с шагом 5
=end

# Вариант №1 цикл
start = 10
result = []
while start <= 100 do
    result << start
    start += 5
end
puts result.inspect

# Вариант №2 step
result = []
10.step(100, 5) {|x| result << x }
puts result.inspect

# Вариант №3 красивый
result = [*10.step(100, 5)]
puts result.inspect
