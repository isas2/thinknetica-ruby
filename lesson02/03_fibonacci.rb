=begin
Заполнить массив числами фибоначчи до 100
=end

result = [1, 1]
loop do
    next_number = result[-2] + result[-1]
    break if next_number >= 100
    result << next_number        
end

puts "Числа фибоначи до 100:"
puts result