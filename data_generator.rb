require_relative 'errors/undefined_value_type_error'

class DataGenerator
  def initialize
    @state = {}
  end

  def generate(column)
    if column['data_type'] == 'string' && column['value_type'] == 'random'
      random_string(column['options']['length'])
    elsif column['data_type'] == 'number' && column['value_type'] == 'sequential'
      sequential_number(column['name'], column['start'], column['increment'])
    else
      raise UndefinedValueTypeError
    end
  end

  private

  def random_string(length = 10)
    "'#{Array.new(length) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join}'"
  end

  def sequential_number(column_name, start = 1, increment = 1)
    @state[column_name] =
      if @state.key? column_name
        @state[column_name] + increment
      else
        start
      end
  end
end
