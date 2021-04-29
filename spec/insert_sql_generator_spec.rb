require_relative '../insert_sql_generator'

describe 'InsertSqlGenerator' do
  let(:insert_sql_generator) { InsertSqlGenerator.new('spec_test_configuration.yml') }
  let(:sql_file_name) { 'spec_test_table_insert_statements.sql' }
  let(:number_of_statements) { 2 }

  shared_examples 'sql file writer' do
    after { File.delete(sql_file_name) if File.exist? sql_file_name }

    it 'writes sql statements to file' do
      expect(File.read(sql_file_name).lines.count).to eq(number_of_statements)
    end
  end

  describe '#run' do
    before { insert_sql_generator.send(:run) }

    it_behaves_like 'sql file writer'
  end

  describe '#write_sql_file' do
    before do
      insert_sql_generator.send(
        :write_sql_file,
        insert_sql_generator.send(:insertion_statements)
      )
    end

    it_behaves_like 'sql file writer'
  end

  describe '#sql_file_name' do
    it 'creates filename from table name' do
      expect(insert_sql_generator.send(:sql_file_name)).to eq(sql_file_name)
    end
  end

  describe '#insertion_statements' do
    let(:statements) { insert_sql_generator.send(:insertion_statements) }
    let(:table_and_column_names_matcher) { 
      /INSERT INTO spec_test_table \(name, age, rank, join_date\) VALUES/
    }
    let(:number_of_columns) { 4 }
    let(:bulk_size) { 2 }
    let(:tuples_count_matcher) { 
      /(?:\((?:[\w'\-]+(?:, )?){#{number_of_columns}}\)[,;]{1} ?){#{bulk_size}}/
    }
    
    it 'has sql insert statements with correct number of tuples that have correct number of values' do
      expect(statements[0]).to match(/^#{table_and_column_names_matcher} #{tuples_count_matcher}\n$/)
    end
    it 'has correct number of statements' do
      expect(statements.count).to eq(number_of_statements)
    end
  end

  describe '#column_names' do
    it 'returns names of columns seperated by commas' do
      expect(insert_sql_generator.send(:column_names)).to eq('name, age, rank, join_date')
    end
  end
end
