require 'pry'
VALID_SCRIPT = "valid"
INVALID_SCRIPT = "invalid"

def order_script script
  scenes = []
  there_are_two_options = false  

  splitted_script = script.split(/(\.|<|>)/)[1..-1]

  if splitted_script[0] != "."
    return INVALID_SCRIPT
  end

  splitted_script.each_slice(2) do |delimiter, scene|
    index = scenes.index(scene)

    if index.nil?
      unless delimiter == "<" 
        scenes << scene 
      else
        scenes.insert(scenes.length - 1, scene)
      end
    else
      if delimiter == "<" and index != scenes.length - 2
        there_are_two_options = true
      elsif delimiter != "<" 
        return INVALID_SCRIPT
      end

    end
  end

  if there_are_two_options
    return VALID_SCRIPT
  else
    return scenes
  end
end

def get_result script
  if script == INVALID_SCRIPT
    puts INVALID_SCRIPT 
    return
  end
  if script == VALID_SCRIPT
    puts VALID_SCRIPT
    return 
  end 
  final_result = ""
  script.each do |scene|
    final_result << scene << ","
  end
  final_result[-1] = ''
  puts final_result
end

number_of_scripts = ARGF.readline
ARGF.readlines.each do |script|
  ordered_script = order_script script.strip
  get_result ordered_script
end
