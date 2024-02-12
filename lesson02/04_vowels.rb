=begin
Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).
=end

result = {}
# По условию задачи непонятно, русские буквы или латинские
('a'..'z').each_with_index do |x, i| 
    result[x] = i + 1 if 'aeiou'.include?(x)
end
puts result.inspect