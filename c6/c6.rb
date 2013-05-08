$total_min_value = 2**31
CAN_MOVE_RIGHT = 0
CAN_MOVE_LEFT = 1
CAN_MOVE_UP = 2
CAN_MOVE_DOWN = 3

OBSTACLE = "#"
ACTUAL_POSITION = "X"
EXIT = "O"

def is_up_free? pos, game_field
  return game_field[pos.last[0] - 1][pos.last[1]] != OBSTACLE
end

def is_down_free? pos, game_field
  return game_field[pos.last[0] + 1][pos.last[1]] != OBSTACLE
end

def is_left_free? pos, game_field
  return game_field[pos.last[0]][pos.last[1] - 1] != OBSTACLE
end

def is_right_free? pos, game_field
  return game_field[pos.last[0]][pos.last[1] + 1] != OBSTACLE
end

def is_last_move_vertical? pos
  if pos.length <= 1
    return false
  else
    return pos.last[0] != pos[-2][0]
  end
end

def is_last_move_horizontal? pos
  if pos.length <= 1
    return false
  else
    return pos.last[1] != pos[-2][1]
  end
end

def possible_next_steps pos, game_field
  possible = []
  unless is_last_move_vertical? pos
    if is_up_free? pos, game_field
      possible << CAN_MOVE_UP
    end
    if is_down_free? pos, game_field
      possible << CAN_MOVE_DOWN
    end
  end
  unless is_last_move_horizontal? pos
    if is_right_free? pos, game_field
      possible << CAN_MOVE_RIGHT
    end
    if is_left_free? pos, game_field
      possible << CAN_MOVE_LEFT
    end
  end
  possible
end

def has_to_stop? pos, game_field
  if game_field[pos[0]][pos[1]] == OBSTACLE 
    return OBSTACLE
  elsif game_field[pos[0]][pos[1]] == EXIT
    return EXIT
  else
    return false
  end
end


def next_pos last_pos, can_move, game_field
  case can_move
  when CAN_MOVE_UP
    (0..(last_pos[0] - 1)).reverse_each do |index|
      result = has_to_stop?([index,last_pos[1]], game_field)
      if result == OBSTACLE
        return [index + 1,last_pos[1]]
      end
      if result == EXIT
        return [index, last_pos[1]]
      end
    end
  when CAN_MOVE_DOWN
    ((last_pos[0] + 1)..(game_field.length - 1)).each do |index|
      result = has_to_stop? [index,last_pos[1]], game_field 
      if result == OBSTACLE 
        return [index - 1, last_pos[1]]
      end
      if result == EXIT
        return [index, last_pos[1]]
      end
    end
  when CAN_MOVE_LEFT
    (0..(last_pos[1] - 1)).reverse_each do |index|
      result = has_to_stop? [last_pos[0], index], game_field
      if result == OBSTACLE
        return [last_pos[0], index + 1]
      end
      if result == EXIT
        return [last_pos[0], index]
      end
    end
  when CAN_MOVE_RIGHT
    ((last_pos[1] + 1)..(game_field[0].length - 1)).each do |index|
      result = has_to_stop? [last_pos[0], index], game_field
      if result == OBSTACLE
        return [last_pos[0], index - 1]
      end
      if result == EXIT
        return [last_pos[0], index]
      end
    end
  end

end

def arrive_to_exit? pos, game_field
  game_field[pos[0]][pos[1]] == EXIT
end

def check_value last_positions, speed, wait
  sum = 0
  last_positions.each_cons(2) do |first, last|
    sum = sum + ((first[0] - last[0] + first[1] - last[1]).abs + 0.0) / speed
  end
  sum = sum + (wait * (last_positions.length - 1) )
  sum = sum.round
end

def min_value last_positions, game_field, speed, wait
  possible_moves = possible_next_steps(last_positions, game_field)
  until possible_moves.empty?
    new_pos = next_pos last_positions.last, possible_moves.delete_at(0), game_field
    if last_positions.include? new_pos
      return false;
    end    
    new_last_positions = last_positions.clone
    new_last_positions << new_pos
    if check_value(new_last_positions, speed, wait) > $total_min_value
      return false;
    end
    if arrive_to_exit? new_pos, game_field
      actual_min_value = check_value(new_last_positions, speed, wait)
      if actual_min_value < $total_min_value
        $total_min_value = actual_min_value
      end
    else
      min_value new_last_positions, game_field, speed, wait
    end
  end
end


number = ARGF.readline.to_i
  
number.times do |x|
  width, height, speed, wait  = ARGF.readline.split(/\s/)
  m = Array.new(height.to_i)
  height.to_i.times do |t| 
    m[t] = ARGF.readline.split(//)
  end
  current_pos = []
  m.each_with_index do |row, n_row|
    index = row.index(ACTUAL_POSITION)
    if index
      current_pos = [n_row, index]
      break
    end
  end

  min_value [current_pos], m, speed.to_i, wait.to_i
  puts $total_min_value
  $total_min_value = 2**31
end

