require 'yaml'

class YamlParser
  YAML_FILE_NAME = 'insert_spec.yaml'.freeze

  def parse
    YAML.load_file(YAML_FILE_NAME)
  end
end
