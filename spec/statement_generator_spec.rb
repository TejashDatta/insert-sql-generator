require_relative '../statement_generator'
require_relative '../data_generator'

TABLE_NAME = 'example_table'.freeze
COLUMN_CONFIGURATION = { 'name' => 'random-string', 'age' => 'sequential-integer' }.freeze
BULK_SIZE = 2

describe 'StatementGenerator' do
  subject(:statement_generator) do
    StatementGenerator.new(
      TABLE_NAME,
      COLUMN_CONFIGURATION,
      BULK_SIZE,
      DataGenerator.new
    )
  end

  describe '#generate' do
    it 'creates an insert sql statement' do
      expect(statement_generator.generate).to match(/^INSERT INTO #{TABLE_NAME} \(name, age\) VALUES .*;/)
    end
  end

  describe '#column_names' do
    it 'returns names of columns seperated by commas' do
      expect(statement_generator.send(:column_names)).to eq('name, age')
    end
  end

  describe '#create_tuples' do
    it 'creates a comma seperated list of tuples' do
      expect(statement_generator.send(:create_tuples).split('),').count).to eq(BULK_SIZE)
    end
  end

  describe '#create_tuple' do
    it 'creates a list of comma seperated values for all columns' do
      expect(statement_generator.send(:create_tuple).split(',').count).to eq(COLUMN_CONFIGURATION.count)
    end
  end
end
