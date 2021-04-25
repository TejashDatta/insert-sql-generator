TABLE_NAME = 'example_table'.freeze
COLUMNS = [
  { 
    'name' => 'name',
    'data_type' => 'string',
    'value_type' => 'random',
    'length' => 5
  },
  {
    'name' => 'age',
    'data_type' => 'number',
    'value_type' => 'sequential',
    'length' => 2,
    'increment' => 5
  }
].freeze
