require_relative '../data_generator'

RANDOM_STRING_REGEX = /^'\w{5}'$/.freeze

describe 'DataGenerator' do
  let(:data_generator) { DataGenerator.new }

  describe '#generate' do
    context 'when column is random string of length 5' do
      let(:column) {
        { 'data_type' => 'string', 'value_type' => 'random', 'length' => 5 }
      }
      
      it 'generates random string of length 5' do
        expect(data_generator.generate(column)).to match(RANDOM_STRING_REGEX)
      end
    end

    context 'when column is random number with range [5, 10]' do
      let(:column) {
        { 'data_type' => 'number', 'value_type' => 'random', 'range' => [5, 10] }
      }
      
      it 'generates a random number between 5 and 10' do
        expect(data_generator.generate(column)).to be_between(5, 10)
      end
    end

    context 'when column is sequential number with start=2 and increment=5' do
      let(:column) {
        { 'data_type' => 'number', 'value_type' => 'sequential', 'start' => 2, 'increment' => 5 }
      }

      it 'generates numbers starting from 2 incrementing by 5' do
        expect(data_generator.generate(column)).to eq(2)
        expect(data_generator.generate(column)).to eq(7)
      end
    end
  end

  describe '#random_string' do
    it 'generates a string of length 5 that has only letters and numbers' do
      expect(data_generator.send(:random_string, length: 5)).to match(RANDOM_STRING_REGEX)
    end
  end

  describe '#random_number' do
    it 'generates a random number between 5 and 10' do
      expect(data_generator.send(:random_number, range: [5, 10])).to be_between(5, 10)
    end
  end

  describe '#sequential_number' do
    it 'increments numbers by 5 starting from 2' do
      expect(data_generator.send(:sequential_number, 'example_column', start: 2, increment: 5)).to eq(2)
      expect(data_generator.send(:sequential_number, 'example_column', start: 2, increment: 5)).to eq(7)
    end
  end
end
