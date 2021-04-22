require 'yaml'
require_relative 'data_generator'
require_relative 'statement_generator'

class InsertSqlGenerator
  def run(yaml_configuration_file_path)
    configuration = YAML.load_file(yaml_configuration_file_path)
    configuration['tables'].each do |table_configuration|
      write_to_sql_file(
        table_configuration['name'],
        table_configuration['columns'],
        table_configuration['number_of_records'],
        table_configuration['size_of_bulk']
      )
    end
  end

  def write_to_sql_file(table_name, column_configuration, number_of_records, bulk_size)
    data_generator = DataGenerator.new
    File.open("insert.sql", "w+") do
      number_of_records.times do
        statement_generator.new(
          table_name, 
          column_configuration, 
          bulk_size, 
          data_generator
        ).generate
      end
    end
  end
end

if __FILE__ == $0
  InsertSqlGenerator.new.run(ARGV[0])
end
