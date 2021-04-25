require_relative 'data_generator'

class StatementsGenerator
  def initialize(table_name, columns, number_of_records, bulk_size)
    @table_name = table_name
    @columns = columns
    @number_of_records = number_of_records
    @bulk_size = bulk_size
    @data_generator = DataGenerator.new
    @statements = []
  end

  def generate
    (@number_of_records / @bulk_size).times { add_statement(@bulk_size) }
    remaining_records = number_of_records % bulk_size
    add_statement(remaining_records) if remaining_records.positive?
    @statements
  end
  
  private

  def add_statement(number_of_tuples)
    @statements <<
      "INSERT INTO #{@table_name} (#{column_names}) VALUES #{create_tuples(number_of_tuples)};\n"
  end

  def column_names
    @columns.map { |column| column['name'] }.join(', ')
  end

  def create_tuples(number_of_tuples)
    [*0...number_of_tuples].map { "(#{create_tuple})" }.join(', ')
  end

  def create_tuple
    @columns
      .map { |column| @data_generator.generate(column) }
      .join(', ')
  end
end
