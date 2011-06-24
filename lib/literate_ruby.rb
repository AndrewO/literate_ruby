module LiterateRuby
  # See comment in the test file
  # def self.require(path)
  #   full_path = path + ".lrb"
  #   if $".include?(full_path)
  #     false
  #   else
  #     if load(full_path)
  #       $" << full_path
  #     else
  #       raise LoadError
  #     end
  #   end
  # end
  
  def self.load(path)
    lines = parse(File.new(path))

    lines.find_all {|(type, line_group)| type == :code && !line_group.empty?}.each do |(_, line_group)|
      Kernel.eval(
        line_group.map {|(line_no, line)| line}.join(""), 
        TOPLEVEL_BINDING, 
        path, 
        line_group[0][0]
      )
    end

    lines
  end

  def self.parse(io)
    state = :open
    lines = []
    buffer = nil
    
    io.readlines.each_with_index do |line, i|
      case line
      when /^>/
        clean_line = line.sub(/^>/, "")
        case state
        when :open
          state = :in_code
          buffer = []
          buffer << [i + 1, clean_line]
        when :in_code
          buffer << [i + 1, clean_line]
        when :in_code_block
          buffer << [i + 1, clean_line]
        when :in_data
          lines << [:data, buffer]
          buffer = []
          
          state = :in_code
          buffer << [i + 1, clean_line]
        end
      when /^=begin_code/
        case state
        when :open
          buffer = []
        when :in_code
          lines << [:code, buffer]
          buffer = []
        when :in_code_block
          buffer << [i + 1, line]
        when :in_data
          lines << [:data, buffer]
          buffer = []
        end
        state = :in_code_block
      when /^=end_code/
        case state
        when :open
          buffer = []
          state = :in_data
        when :in_code
          lines << [:code, buffer]
          buffer = []
          
          state = :in_data
        when :in_code_block
          lines << [:code, buffer]
          buffer = []
          
          state = :in_data
        when :in_data
          # no-op
        end
      else
        case state
        when :open
          buffer = []
          state = :in_data
          buffer << [i + 1, line]
        when :in_code
          lines << [:code, buffer]
          buffer = []
          
          state = :in_data
          buffer << [i + 1, line]
        when :in_code_block
          buffer << [i + 1, line]
        when :in_data
          buffer << [i + 1, line]
        end
      end
    end

    case state
    when :open
      # no-op
    when :in_code
      lines << [:code, buffer] unless buffer.empty?
      buffer = nil
    when :in_code_block
      lines << [:code, buffer] unless buffer.empty?
      buffer = nil
    when :in_data
      lines << [:data, buffer] unless buffer.empty?
      buffer = nil
    end

    lines
  end
end
