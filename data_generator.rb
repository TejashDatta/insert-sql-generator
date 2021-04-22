require_relative 'errors/undefined_value_type_error'

class DataGenerator
  def initialize
    @current_index = -1
  end

  def generate(value_type)
    case value_type
    when 'random-string'
      random_string
    when 'sequential-integer'
      sequential_integer
    else
      raise UndefinedValueTypeError
    end
  end

  def random_string
    "'#{Array.new(10) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join}'"
  end

  def sequential_integer
    @current_index += 1
  end
end
