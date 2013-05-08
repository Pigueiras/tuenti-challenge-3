def check_value positions, game_field
  positions.inject(0) { |sum, position| sum + game_field[position[0]][position[1]] }
end


$max_value = 0

def max_value_path previous_positions, total_moves, game_field

  # Break if there is no possibility of reaching max_value
  if (check_value(previous_positions, game_field) + (total_moves - (previous_positions.length - 1)) * 5) < $max_value
    return false
  end

  children = possible_next_steps( previous_positions, game_field )
  until children.empty?
    new_previous_positions = previous_positions.clone    
    new_previous_positions << children.delete_at(0) # Delete first

    if total_moves == previous_positions.length - 1 
      if $max_value < check_value( previous_positions, game_field)
        $max_value = check_value( previous_positions, game_field )
      end

    else
      max_value_path new_previous_positions, total_moves, game_field
    end
  end
end

def is_top? position
  position.first == 0
end

def is_bottom? position, game_field
  position.first == game_field.length - 1
end

def is_left? position
  position.last == 0
end

def is_right? position, game_field
  position.last == game_field[0].length - 1
end

def has_one_element? positions
  positions.length == 1
end

def last_was_top? positions
  if has_one_element? positions
    return false
  else  
    return positions.last[0] - 1 == positions[-2][0] 
  end
end

def last_was_bottom? positions
  if has_one_element? positions
    return false
  else
    return positions.last[0] + 1  == positions[-2][0]  
  end
end

def last_was_left? positions
  if has_one_element? positions
    return false
  else
    return positions.last[1] - 1 == positions[-2][1]  
  end
end

def last_was_right? positions 
  if has_one_element? positions
    return false
  else
    return positions.last[1]+ 1 == positions[-2][1]  
  end
end

def possible_next_steps positions, game_field
  possible = []
  possible_up = [positions.last[0] - 1 , positions.last[1]]
  possible_bottom = [positions.last[0] + 1, positions.last[1]]
  possible_left = [positions.last[0], positions.last[1] - 1]
  possible_right = [positions.last[0], positions.last[1] + 1]

  if !is_top?( positions.last ) and !last_was_top?( positions ) and !positions.include?(possible_up)
    possible << possible_up
  end 
  if !is_left?( positions.last ) and !last_was_left?( positions ) and !positions.include?(possible_left)
    possible << possible_left
  end
  if !is_bottom?( positions.last, game_field) and !last_was_bottom?( positions ) and !positions.include?(possible_bottom)
    possible << possible_bottom
  end
  if !is_right?( positions.last, game_field) and !last_was_right?( positions ) and !positions.include?(possible_right)
    possible << possible_right
  end

  return possible
end


number_of_tests = ARGF.readline.to_i
 
number_of_tests.times do |times|
   width, height = ARGF.readline.split(/,/)
   game_field = Array.new(width.to_i) { |i| Array.new(height.to_i, 0) }
   first_position = ARGF.readline.split(/,/)
   first_position.map! {|x| x.to_i }
   moves = ARGF.readline.to_i
   ARGF.readline # Useless
 
   ARGF.readline.split("#").each do |gem|
     x, y, value = gem.split(",")
     game_field[x.to_i][y.to_i] = value.to_i
   end
   max_value_path [first_position], moves, game_field 
   puts $max_value
   $max_value = 0
end

