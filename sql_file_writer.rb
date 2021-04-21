class SqlFileWriter
  SQL_FILENAME = 'insert.sql'.freeze
  
  def file_path
    File.join(__dir__, SQL_FILENAME)
  end

  def write(sql_statement)
    File.write(file_path, sql_statement)
  end
end
