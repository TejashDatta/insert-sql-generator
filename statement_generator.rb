class StatementGenerator
  def initialize(table_name, column_configuration, bulk_size, data_generator)
    @table_name = table_name
    @column_configuration = column_configuration
    @bulk_size = bulk_size
    @data_generator = data_generator
  end

  def generate
    "INSERT INTO #{@table_name} (#{column_names}) VALUES #{create_tuples};"
  end

  private

  def column_names
    @column_configuration.keys.join(', ')
  end

  def create_tuples
    [*0...@bulk_size].map { "(#{create_tuple})" }.join(', ')
  end

  def create_tuple
    @column_configuration
      .values
      .map { |column_data_type| @data_generator.generate(column_data_type) }
      .join(', ')
  end
end
