ARGF.each_line do |line|
  puts line.split( /\s/ ).map {|x| x.to_i }.reduce(:+)
end
