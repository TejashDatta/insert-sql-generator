require 'yaml'
require_relative 'statements_generator'

SQL_FILE_NAME = 'insert.sql'.freeze

class InsertSqlGenerator
  def initialize(yaml_configuration_file_path)
    @configuration = YAML.load_file(yaml_configuration_file_path)
    @statements = []
  end

  def run
    create_statements_for_all_tables
    write_sql_file
  end

  private

  def create_statements_for_all_tables
    @configuration['tables'].each do |table|
      @statements += StatementsGenerator.new(
        table['name'],
        table['columns'],
        table['number_of_records'],
        table['size_of_bulk']
      ).generate
    end
  end

  def write_sql_file
    File.open(SQL_FILE_NAME, 'w') do |file|
      @statements.each { |statement| file.write statement }
    end
  end
end

if __FILE__ == $0
  InsertSqlGenerator.new(ARGV[0]).run
end
