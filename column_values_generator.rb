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
      random_numbers(lower_limit: column['lower_limit'], upper_limit: column['upper_limit'])
    when 'sequential number'
      sequential_numbers(start: column['start'], increment: column['increment'])
    when 'sequential date'
      sequential_dates(start: column['start'], day_increment: column['day_increment'])
    end
  end

  private

  def random_strings(length: 10)
    @number_of_records.times.map do
      "'#{Array.new(length) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join}'"
    end
  end

  def random_numbers(lower_limit: 1, upper_limit: 100_000)
    @number_of_records.times.map { rand(lower_limit..upper_limit) }
  end
  
  def sequential_numbers(start: 1, increment: 1)
    @number_of_records.times.map { |index| start + index * increment }
  end

  def sequential_dates(start: Date.today.to_s, day_increment: 1)
    @number_of_records.times.map { |index| "'#{Date.parse(start) + index * day_increment}'" }
  end
end
