def seconds_for_given_parameters width, height, soldiers, crematoriums
  array = Array.new( height + 1, 0)
  array[0] = width
  counter = 0 
  last_index = 0

  until array[height] != 0

    array[last_index + 1] = array[last_index]

    if soldiers < array[last_index + 1]
      array[last_index + 1] = array[last_index + 1] - soldiers
      array[last_index] = width
      last_index = last_index + 1
    else
      array[last_index + 1] = 0
      array[last_index] = array[last_index] + width - soldiers
    end

    counter = counter + 1
  end

  counter * (crematoriums + 1)
end

def possibilities_for_gold gold, price_soldiers, price_crem
  possibles = []
  soldiers = gold / price_soldiers
  last_crematoriums = -1
  until soldiers < 0
    crematoriums = (gold - soldiers * price_soldiers) / price_crem
    if last_crematoriums != crematoriums
      possibles << [soldiers, crematoriums]
    end
    soldiers = soldiers - 1
    last_crematoriums = crematoriums
  end
  possibles
end

def resistance_in_seconds test
  width = test[0]
  height = test[1]
  gold_for_soldier = test[2]
  gold_for_crem = test[3]
  gold = test[4]

  max_seconds = 0

  if gold/gold_for_soldier >= width
    return -1
  end

  possibilities = possibilities_for_gold( gold, gold_for_soldier, gold_for_crem )
  possibilities.each do |possibility|
    soldiers = possibility.first
    crems = possibility.last
    seconds = seconds_for_given_parameters width, height, possibility.first, possibility.last
    div = width / (width - soldiers)
    mod = width % (width - soldiers)

    if seconds > max_seconds
      max_seconds = seconds
    end
  end
  max_seconds
end

number_of_tests = ARGF.readline.to_i

number_of_tests.times do |times|
  test = ARGF.readline.split(/\s/)
  test.map! { |x| x.to_i }
  puts resistance_in_seconds test
end
