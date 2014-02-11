=begin
While considering single responsibilities and a separation of concerns for this project, I initially considered
there to be as many as three classes: Configuration, Section, and Parser. However, for the scope of this exercise,
I felt it was easier to condense the responsibilities into a single class with a majority of the inner machinery
determined through private methods. In place of a Configuration class, I have included an instance variable
(@configuration) instantiated as an empty hash, which will be built via private methods and indexed by its
getter and setter methods. In place of a Section class, I have designed a parse_file method, along with several 
other private methods using regular expressions, to determine how to organize the files by section name and key.
=end

class Parser
  def initialize(file_name)
    @file = File.open(file_name, 'r+')
    @configuration = {}
    parse_file
  end

  def get_string(section, key)
    get_value(section, key).to_s
  end

  def get_integer(section, key)
    Integer(get_value(section, key))
  end

  def get_float(section, key)
    Float(get_value(section, key))
  end

  def set_string(section, key, value)
    set_value(section, key, value.to_s)
  end

  def set_integer(section, key, value)
    set_value(section, key, Integer(value))
  end

  def set_float(section, key, value)
    set_value(section, key, Float(value))
  end
  
=begin
As you can see, between the shared responsibilities of the getter/setter methods, I decided to separate the
responsibility for initially indexing a hash value (in the private methods) from the responsibility to ensure
that each object was being returned as an instance of the appropriate class (public methods). Within the logic
for set_value, I pre-set each section as an empty hash if its value is not already determined. In build_output,
I construct how each section, along with its keys and values, will be rendered in the view. In write_file, I
reset the @file object each time a setter is called and write the new set of values to file.
=end

  private

  def get_value(section, key)
    @configuration[section][key]
  end

  def set_value(section, key, value)
    @configuration[section] ||= {}
    @configuration[section][key] = value
    write_file
    value
  end

  def build_output
    output = ""
    @configuration.each do |section, keys|
      output << "[#{section}]\n"
      keys.each do |key, value|
        output << "#{key} : #{value}\n"
      end
    end
    output
  end

  def write_file
    @file.rewind
    output = build_output
    @file.write(output)
  end

  def parse_file    
    @file.readlines.each_with_index do |line, index|
      if match = check_section(line)
        set_section(match)
      elsif match = check_key_value(line)
        set_key_value(match)
      elsif match = check_value_continuation(line)
        set_value_continuation(match)
      elsif not check_blank_line(line)
        raise_exception
      end
    end
  end

  def check_section(line)
    line.match /^\[((\s*\S)+)\s*\]\s*$/
  end

  def check_key_value(line)
    line.match /^(?<key>(\w+\s*)+)\s*:\s*(?<value>(\S+\s*)+)\s*$/
  end

  def check_value_continuation(line)
    line.match /^\s+(?<value>(\S+\s*)+)\s*$/
  end

  def check_blank_line(line)
    line.match /^\s*$/
  end

  def set_section(match)
    @current_section = match[1].strip
    @configuration[@current_section] = {}
  end

  def set_key_value(match)
    if @current_section
      @current_key = match[:key].strip
      @configuration[@current_section][@current_key] = match[:value].strip
    else
      raise_exception
    end
  end

  def set_value_continuation(match)
    if @current_key
      @configuration[@current_section][@current_key] += " #{match[:value].strip}"
    else
      raise_exception
    end
  end

  def raise_exception(message = "Parser error")
    raise Exception.new(message)
  end
end
