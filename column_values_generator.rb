require 'date'

class ColumnValuesGenerator
  def initialize(number_of_records)
    @number_of_records = number_of_records
  end

  def generate(column)
    case "#{column['value_type']} #{column['data_type']}"
    when 'random string'
      random_strings(length: column['length'])
    when 'random number'
      random_numbers(range: column['range'])
    when 'sequential number'
      sequential_numbers(start: column['start'], increment: column['increment'])
    when 'sequential date'
      sequential_dates(start: column['start'], day_increment: column['day_increment'])
    end
  end

  def random_strings(length: 10)
    (0...@number_of_records).map do
      "'#{Array.new(length) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join}'"
    end
  end

  def random_numbers(range: [1, 100_000])
    (0...@number_of_records).map { rand(range[0]..range[1]) }
  end
  
  def sequential_numbers(start: 1, increment: 1)
    (0...@number_of_records).map { |index| start + index * increment }
  end

  def sequential_dates(start: Date.today.to_s, day_increment: 1)
    (0...@number_of_records).map { |index| "'#{Date.parse(start) + index * day_increment}'" }
  end
end
