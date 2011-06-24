module LiterateRuby
  def self.require(path)
    
  end
  
  def self.load(path)
    
  end
  
  def self.eval(string)
    
  end
  
  def self.parse(io)
    state = :not_in_code_block
    lines = []

    io.readlines.each do |line|
      case line
      when /^>/
        lines << [:code, line.sub(/^>/, "")]
      when /^=begin/
        state = :in_code_block
      when /^=end/
        state = :not_in_code_block
      else
        if state == :in_code_block
          lines << [:code, line]
        else
          lines << [:data, line]
        end
      end
    end
    
    lines
  end
end
