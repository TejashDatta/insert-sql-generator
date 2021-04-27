require 'yaml'
require_relative 'column_values_generator'

class InsertSqlGenerator
  def initialize(yaml_configuration_file_path)
    table = YAML.load_file(yaml_configuration_file_path)
    @table_name = table['name']
    @columns = table['columns']
    @number_of_records = table['number_of_records']
    @bulk_size = table['size_of_bulk']
    @statements = []
  end

  def run
    create_statements
    write_sql_file
  end

  private

  def create_statements
    tuples = create_tuples
    @statements = (0...@number_of_records).step(@bulk_size).map do |index|
      "INSERT INTO #{@table_name} (#{column_names}) VALUES #{tuples[index, @bulk_size].join(', ')};\n"
    end
  end

  def create_tuples
    column_values_generator = ColumnValuesGenerator.new(@number_of_records)
    @columns
      .map { |column| column_values_generator.generate(column) }
      .transpose
      .map { |row_values| row_values.join(', ') }
      .map { |tuple| "(#{tuple})" }
  end

  def column_names
    @columns.map { |column| column['name'] }.join(', ')
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
