=begin
Сумма покупок.
Пользователь вводит поочередно название товара, цену за единицу и кол-во купленного товара (может быть нецелым числом).
Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп" в качестве названия товара.
На основе введенных данных требуетеся:
    - Заполнить и вывести на экран хеш, ключами которого являются названия товаров, 
      а значением - вложенный хеш, содержащий цену за единицу товара и кол-во купленного товара. 
      Также вывести итоговую сумму за каждый товар.
    - Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
=end

basket = {}
loop do
    print "Введите название товара: "
    name = gets.chomp
    break if name == 'стоп'

    print "Введите цену за единицу: "
    price = gets.chomp.to_i

    print "Введите кол-во купленного товара: "
    amount = gets.chomp.to_f
    
    basket[name] = {price: price, amount: amount}
end

total = 0
basket.each do |name, params|
    puts "#{name} (#{params[:amount].round(2)} по #{params[:price]} руб): #{(params[:amount] * params[:price]).round(2)} руб"
    total += params[:amount] * params[:price]
end
puts "Итоговая сумма за все товары: #{total.round(2)} руб"