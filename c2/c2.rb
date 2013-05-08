def process_word word
  word.strip.chars.sort.join
end

def get_dictionary_with_ordered_words dictionary_name
  file = File.new dictionary_name, "r"
  processed_dictionary = {}
  File.open(dictionary_name, "r").each_line do |word|
    processed_word = process_word word
    if processed_dictionary[ processed_word ].nil?
      processed_dictionary[ processed_word ] = [word.strip]
    else
      processed_dictionary[ processed_word ] << word.strip
    end
  end

  processed_dictionary
end

ARGF.readline # Ignore line
dictionary_name = ARGF.readline.strip

dictionary = get_dictionary_with_ordered_words dictionary_name 

ARGF.readline # Ignore line
number_of_words = ARGF.readline.to_i

ARGF.readline # Ignore line

number_of_words.times do 
  word = ARGF.readline.strip
  processed_word = process_word word
  print "#{word} ->"
  if dictionary[processed_word]
    dictionary[processed_word].sort.each { |p_word| print " ", p_word if word != p_word} 
  end
  print "\n"
end

