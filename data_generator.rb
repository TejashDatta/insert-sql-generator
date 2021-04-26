class DataGenerator
  def initialize
    @state = {}
  end

  def generate(column)
    case "#{column['value_type']} #{column['data_type']}"
    when 'random string'
      random_string(length: column['length'])
    when 'random number'
      random_number(range: column['range'])
    when 'sequential number'
      sequential_number(column['name'], start: column['start'], increment: column['increment'])
    end
  end

  private

  def random_string(length: 10)
    "'#{Array.new(length) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join}'"
  end

  def random_number(range: [1, 100_000])
    rand(range[0]..range[1])
  end
  
  def sequential_number(column_name, start: 1, increment: 1)
    @state[column_name] =
      if @state.key? column_name
        @state[column_name] + increment
      else
        start
      end
  end
end
