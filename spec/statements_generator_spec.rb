require_relative '../statements_generator'
require_relative '../data_generator'
require_relative 'constants'

NUMBER_OF_RECORDS = 4
BULK_SIZE = 2

describe 'StatementGenerator' do
  let(:statements_generator) do
    StatementsGenerator.new(
      TABLE_NAME,
      COLUMNS,
      NUMBER_OF_RECORDS,
      BULK_SIZE
    )
  end

  describe '#generate' do
  end

  describe '#add_statement' do
    before { statements_generator.send(:add_statement, BULK_SIZE) }

    it 'adds an sql insert statement to @statements' do
      expect(statements_generator.instance_variable_get(:@statements)[0]).to match(
        /^INSERT INTO #{TABLE_NAME} .*;\n$/
      )
    end
  end

  describe '#column_names' do
    it 'returns names of columns seperated by commas' do
      expect(statements_generator.send(:column_names)).to eq('name, age')
    end
  end

  describe '#create_tuples' do
    it 'creates a comma seperated list of tuples' do
      expect(statements_generator.send(:create_tuples, BULK_SIZE).split('),').count).to eq(BULK_SIZE)
    end
  end

  describe '#create_tuple' do
    it 'creates a list of comma seperated values for all columns' do
      expect(statements_generator.send(:create_tuple).split(',').count).to eq(COLUMNS.count)
    end
  end
end
