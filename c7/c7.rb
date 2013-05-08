# Gem needed ruby-dictionary.rb => https://github.com/mhuggins/ruby-dictionary

CHARACTER_MULT = 1
WORD_MULT = 2

class Cell
  attr_reader :score, :letter, :modifier

  def initialize letter, modifier, score
    @score = score
    @letter = letter
    @modifier = modifier
  end
end

require 'ruby-dictionary'
dictionary = Dictionary.from_file("boozzle-dict.txt")

def is_top? position
  position.first == 0
end

def is_bottom? position, board
  position.first == board.length - 1
end

def is_left? position
  position.last == 0
end

def is_right? position, board
  position.last == board[0].length - 1
end

def possible_cells previous_cells, board
  last_cell = previous_cells.last
  possible = []
  possible_up = [last_cell[0] - 1 , last_cell[1]]
  possible_bottom = [last_cell[0] + 1, last_cell[1]]
  possible_left = [last_cell[0], last_cell[1] - 1]
  possible_right = [last_cell[0], last_cell[1] + 1]

  possible_left_up = [last_cell[0] - 1 , last_cell[1] - 1]
  possible_left_bottom = [last_cell[0] + 1, last_cell[1] - 1]
  possible_right_up = [last_cell[0] - 1, last_cell[1] + 1]
  possible_right_bottom = [last_cell[0] + 1, last_cell[1] + 1]
  
  if !is_top?( last_cell ) and !previous_cells.include?(possible_up)
    possible << possible_up
  end

  if !is_top?(last_cell) and !is_left?( last_cell ) and !previous_cells.include?(possible_left_up)
    possible << possible_left_up
  end
  
  if !is_top?(last_cell) and !is_right?( last_cell, board) and !previous_cells.include?(possible_right_up)
    possible << possible_right_up
  end
  
  if !is_bottom?( last_cell, board) and !previous_cells.include?(possible_bottom)
    possible << possible_bottom
  end

  if !is_bottom?(last_cell, board) and !is_right?( last_cell, board) and !previous_cells.include?(possible_right_bottom)
    possible << possible_right_bottom
  end
  if !is_bottom?(last_cell, board) and !is_left?( last_cell ) and !previous_cells.include?(possible_left_bottom)
    possible << possible_left_bottom
  end
  if !is_left?( last_cell ) and !previous_cells.include?(possible_left)
    possible << possible_left
  end
  if !is_right?( last_cell, board) and !previous_cells.include?(possible_right)
    possible << possible_right
  end

  possible
end

def word_from_positions cells, board
  cells.inject("") {|word, cell| word + board[cell[0]][cell[1]].letter.downcase }
end

def word_points cells, board, score
  max_word_multiplier = 1
  points = 0
  cells.each do |cell|
    letter = board[cell[0]][cell[1]].letter
    modifier = board[cell[0]][cell[1]].modifier
    multiplier = board[cell[0]][cell[1]].score

    if modifier == WORD_MULT and max_word_multiplier < multiplier
      max_word_multiplier = multiplier
      points = points + score[letter.capitalize]
    elsif modifier == CHARACTER_MULT
      points = points + score[letter.capitalize] * multiplier    
    else
      points = points + score[letter.capitalize]
    end
  end
  
  return ( points * max_word_multiplier ) + cells.length
end

def possible_words_from_cell previous_cells, board, possible_combinations, dictionary, scores
  possible_cells = possible_cells( previous_cells, board )
  until possible_cells.empty?
    new_previous_cells = previous_cells.clone
    new_previous_cells << possible_cells.delete_at(0)
    
    word = word_from_positions( new_previous_cells, board )
    if dictionary.exists? word
      points = word_points new_previous_cells, board, scores
      possible_combinations[word] ||= points
      if possible_combinations[word] < points
        possible_combinations[word] = points
      end
    end
    unless dictionary.starting_with(word).empty?
      possible_words_from_cell new_previous_cells, board, possible_combinations, dictionary, scores
    end 

  end
end

number_of_tests = ARGF.readline.to_i

number_of_tests.times do |time|
  scores_plain = ARGF.readline.gsub(":", "=>")
  scores = eval(scores_plain)
  seconds = ARGF.readline.to_i
  num_rows = ARGF.readline.to_i
  num_columns = ARGF.readline.to_i
  board = Array.new(num_rows) do |row|
    row_contents = ARGF.readline.split
  end

  (0..num_rows - 1).each do |i|
    (0..num_columns - 1).each do |j|
      board[i][j] = Cell.new(board[i][j][0], board[i][j][1].to_i, board[i][j][2].to_i)
    end
  end

  possible_combinations = {}
  (0..num_rows - 1).each do |i|
    (0..num_columns - 1).each do |j|
       possible_words_from_cell [[i,j]], board, possible_combinations, dictionary, scores
    end
  end

  words = possible_combinations.to_a

  number_of_items,seconds = words.length, seconds
  cache = [].tap { |m| (number_of_items+1).times { m << Array.new(seconds+1) } }
  cache[0].each_with_index { |value, weight| cache[0][weight] = 0  }

  (1..number_of_items).each do |i|
    seconds_to_submit, score = words[i-1][0].length + 1, words[i-1][1]
    (0..seconds).each do |x|
      if seconds_to_submit  > x
        cache[i][x] = cache[i-1][x] 
      else
        cache[i][x] = [cache[i-1][x], cache[i-1][x - seconds_to_submit] + score].max
      end
    end
  end

  puts cache[number_of_items][seconds]

end
