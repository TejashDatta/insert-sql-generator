require_relative '../insert_sql_generator'

describe 'InsertSqlGenerator' do
  let(:insert_sql_generator) { InsertSqlGenerator.new('spec_test_configuration.yml') }
  let(:sql_file_name) { 'spec_test_table_insert_statements.sql' }

  shared_examples 'sql file writer' do
    after { File.delete(sql_file_name) if File.exist? sql_file_name }

    it 'writes sql statements to file' do
      expect(File.read(sql_file_name).lines.count).to eq(2)
    end
  end

  describe '#run' do
    before { insert_sql_generator.send(:run) }

    it_behaves_like 'sql file writer'
  end

  describe '#generate_tuples' do
    before { insert_sql_generator.send(:generate_tuples_to_insert) }
    let(:tuples) { insert_sql_generator.instance_variable_get(:@tuples_to_insert) }
    
    it 'has tuples that have values for all columns' do
      expect(tuples[0].split(', ').count).to eq(4)
    end
    it 'has number of tuples = number of records' do
      expect(tuples.count).to eq(3)
    end
  end

  describe '#generate_insert_statements' do
    before do
      insert_sql_generator.send(:generate_tuples_to_insert)
      insert_sql_generator.send(:generate_insert_statements)
    end
    let(:statements) { insert_sql_generator.instance_variable_get(:@insert_statements) }
    
    it 'has sql insert statements' do
      expect(statements[0]).to match(/^INSERT INTO spec_test_table .*;\n$/)
    end
    it 'has correct number of statements' do
      expect(statements.count).to eq(2)
    end
  end

  describe '#join_column_names' do
    it 'returns names of columns seperated by commas' do
      expect(insert_sql_generator.send(:join_column_names)).to eq('name, age, rank, join_date')
    end
  end

  describe '#write_sql_file' do
    before do
      insert_sql_generator.send(:generate_tuples_to_insert)
      insert_sql_generator.send(:generate_insert_statements)
      insert_sql_generator.send(:write_sql_file)
    end

    it_behaves_like 'sql file writer'
  end

  describe '#create_sql_file_name' do
    it 'creates filename from table name' do
      expect(insert_sql_generator.send(:create_sql_file_name)).to eq(sql_file_name)
    end
  end
end
