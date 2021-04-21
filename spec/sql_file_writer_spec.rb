require_relative '../sql_file_writer'

describe 'SqlFileWriter' do
  SQL_FILE_PATH = File.join(File.expand_path('..', __dir__), 'test_insert.sql').freeze

  let(:sql_file_writer) { SqlFileWriter.new }
  SqlFileWriter::SQL_FILENAME = 'test_insert.sql'.freeze

  describe '#file_path' do
    it "returns path of test_insert.sql in project directory" do
      expect(sql_file_writer.file_path).to eq(SQL_FILE_PATH)
    end
  end

  describe '#write' do
    CONTENT = '<sql statement>'.freeze
    before { sql_file_writer.write(CONTENT) }

    it 'writes correctly to sql file' do
      expect(File.read(SQL_FILE_PATH)).to eq(CONTENT)
    end

    after { File.delete(SQL_FILE_PATH) if File.exist? SQL_FILE_PATH }
  end
end
