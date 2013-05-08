require 'digest/md5'
require 'zlib'


class Fixnum
  def mult_s string
    begin
      return string * self
    rescue
      # If an error with a big string exists, we compress it
      return "[#{Zlib::Deflate.deflate(string)}]" * self
    end 
  end
end

def parse_input expression
  return expression.gsub(/\]([a-z0-9])/, ']+\1')
      .gsub(/([a-z])([0-9])/, '\1+\2')
      .gsub(/([a-z])+/, ' \'\0\' ')
      .gsub("[", ".mult_s(")
      .gsub("]", ")")
end

ARGF.readlines.each do |line|

  eval( parse_input(line) ).gsub( /\[([^]]+)\]/ ) {|match| Zlib::Inflate.inflate(match[1..-1])} 
  puts Digest::MD5.hexdigest( 

end

