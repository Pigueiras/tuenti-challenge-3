def max_earning budget, exchange_currencies 
  selling = false
  euros_per_bitcoin = budget 
  bitcoins = -1

  exchange_currencies.each_cons(2) do |last, current|
    if selling and current < last 
      euros_per_bitcoin = bitcoins * last 
      selling = false
    elsif !selling and current > last
      selling = true
      if euros_per_bitcoin % last == 0
        bitcoins = euros_per_bitcoin / last 
      end
    end
  end
  
  if bitcoins != -1 and exchange_currencies.length >= 2 and exchange_currencies[-1] > exchange_currencies[-2]
    euros_per_bitcoin = bitcoins * exchange_currencies[-1]
  end

  return euros_per_bitcoin

end

number_of_tests = ARGF.readline.to_i

number_of_tests.times do |line|
  budget = ARGF.readline.to_i
  currencies = ARGF.readline.split(/\s/).map { |x| x.to_i }
  puts max_earning( budget, currencies )
end

