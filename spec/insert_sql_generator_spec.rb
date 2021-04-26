require_relative '../insert_sql_generator'

SQL_FILE_NAME = 'example_table_insert_statements.sql'.freeze
NUMBER_OF_STATEMENTS = 3

describe 'InsertSqlGenerator' do  
  let(:insert_sql_generator) { InsertSqlGenerator.new('test_configuration.yml') }

  shared_examples 'sql file writer' do
    after { File.delete(SQL_FILE_NAME) if File.exist? SQL_FILE_NAME }

    it 'writes sql statements to file' do
      expect(File.read(SQL_FILE_NAME).lines.count).to eq(NUMBER_OF_STATEMENTS)
    end
  end

  describe '#run' do
    before { insert_sql_generator.send(:run) }

    it_behaves_like 'sql file writer'
  end

  describe '#create_statements' do
    before { insert_sql_generator.send(:create_statements) }

    it 'populates @statements with insert statements' do
      expect(insert_sql_generator.instance_variable_get(:@statements).count).to eq(NUMBER_OF_STATEMENTS)
    end
  end

  describe '#create_statement' do
    before { insert_sql_generator.send(:create_statement, 4) }

    it 'adds an sql insert statement to @statements' do
      expect(insert_sql_generator.instance_variable_get(:@statements)[-1]).to match(
        /^INSERT INTO example_table .*;\n$/
      )
    end
  end

  describe '#column_names' do
    it 'returns names of columns seperated by commas' do
      expect(insert_sql_generator.send(:column_names)).to eq('name, age, rank')
    end
  end

  describe '#create_tuples' do
    it 'creates a comma seperated list of tuples' do
      expect(insert_sql_generator.send(:create_tuples, 4).split('),').count).to eq(4)
    end
  end

  describe '#create_tuple' do
    it 'creates a list of comma seperated values for all columns' do
      expect(insert_sql_generator.send(:create_tuple).split(',').count).to eq(3)
    end
  end

  describe '#write_sql_file' do
    before do
      insert_sql_generator.send(:create_statements)
      insert_sql_generator.send(:write_sql_file)
    end  

    it_behaves_like 'sql file writer'
  end

  describe '#sql_file_name' do
    it 'creates filename from table name' do
      expect(insert_sql_generator.send(:sql_file_name)).to eq(SQL_FILE_NAME)
    end
  end
end
