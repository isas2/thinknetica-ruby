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