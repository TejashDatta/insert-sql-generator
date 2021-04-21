require_relative '../yaml_parser'

describe 'YamlParser' do
  describe '#parse' do
    YamlParser::YAML_FILE_NAME = 'test.yaml'

    it 'parses yaml file correctly' do
      expect(YamlParser.new.parse).to eq({ "a" => 1, "b" => 2 })
    end
  end
end
