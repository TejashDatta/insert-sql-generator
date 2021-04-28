require 'yaml'
require_relative 'column_values_generator'

class InsertSqlGenerator
  def initialize(yaml_configuration_file_path)
    table = YAML.load_file(yaml_configuration_file_path)
    @table_name = table['name']
    @columns = table['columns']
    @number_of_records = table['number_of_records']
    @bulk_size = table['size_of_bulk']
    @tuples_to_insert = []
    @insert_statements = []
  end

  def run
    generate_tuples_to_insert
    generate_insert_statements
    write_sql_file
  end

  private

  def generate_tuples_to_insert
    column_values_generator = ColumnValuesGenerator.new(@number_of_records)
    @tuples_to_insert = 
      @columns
        .map { |column| column_values_generator.generate(column) }
        .transpose
        .map { |row_values| "(#{row_values.join(', ')})" }
  end

  def generate_insert_statements
    @insert_statements = 
      0.step(@number_of_records - 1, @bulk_size).map do |index|
        "INSERT INTO #{@table_name} (#{join_column_names}) " \
        "VALUES #{@tuples_to_insert[index, @bulk_size].join(', ')};\n"
      end
  end

  def join_column_names
    @columns.map { |column| column['name'] }.join(', ')
  end

  def write_sql_file
    File.open(create_sql_file_name, 'w') do |file|
      @insert_statements.each { |statement| file.write statement }
    end
  end

  def create_sql_file_name
    "#{@table_name}_insert_statements.sql"
  end
end

if __FILE__ == $0
  InsertSqlGenerator.new(ARGV[0]).run
end
