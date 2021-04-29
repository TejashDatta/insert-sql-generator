require 'yaml'
require_relative 'column_values_generator'

class InsertSqlGenerator
  def initialize(yaml_configuration_file_path)
    table = YAML.load_file(yaml_configuration_file_path)
    @table_name = table['name']
    @columns = table['columns']
    @number_of_records = table['number_of_records']
    @bulk_size = table['size_of_bulk']
  end

  def run
    write_sql_file(insertion_statements)
  end

  private

  def write_sql_file(statements)
    File.open(sql_file_name, 'w') do |file|
      statements.each { |statement| file.write statement }
    end
  end

  def sql_file_name
    "#{@table_name}_insert_statements.sql"
  end

  def insertion_statements
    column_values_generator = ColumnValuesGenerator.new(@number_of_records)
    @columns
      .map { |column| column_values_generator.generate(column) }
      .transpose
      .map { |row_values| "(#{row_values.join(', ')})" }
      .each_slice(@bulk_size)
      .map { |tuples_in_bulk| tuples_in_bulk.join(', ') }
      .map { |tuple_group| "INSERT INTO #{@table_name} (#{column_names}) VALUES #{tuple_group};\n" }
  end

  def column_names
    @columns.map { |column| column['name'] }.join(', ')
  end
end

if __FILE__ == $0
  InsertSqlGenerator.new(ARGV[0]).run
end
