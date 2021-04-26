require 'yaml'
require_relative 'data_generator'

class InsertSqlGenerator
  def initialize(yaml_configuration_file_path)
    table = YAML.load_file(yaml_configuration_file_path)
    @table_name = table['name']
    @columns = table['columns']
    @number_of_records = table['number_of_records']
    @bulk_size = table['size_of_bulk']
    @data_generator = DataGenerator.new
    @statements = []
  end

  def run
    create_statements
    write_sql_file
  end

  private

  def create_statements
    (@number_of_records / @bulk_size).times { create_statement(@bulk_size) }
    remaining_records = @number_of_records % @bulk_size
    create_statement(remaining_records) if remaining_records.positive?
  end
  
  def create_statement(number_of_tuples)
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

  def write_sql_file
    File.open(sql_file_name, 'w') do |file|
      @statements.each { |statement| file.write statement }
    end
  end

  def sql_file_name
    "#{@table_name}_insert_statements.sql"
  end
end

if __FILE__ == $0
  InsertSqlGenerator.new(ARGV[0]).run
end
