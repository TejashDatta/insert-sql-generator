require_relative '../data_generator'

describe 'DataGenerator' do
  let(:data_generator) { DataGenerator.new }

  describe '#random_string' do
    it 'generates a string of length 5 that has only letters and numbers' do
      expect(data_generator.send(:random_string, 5)).to match(/^'\w{5}'$/)
    end
  end

  describe '#sequential_number' do
    it 'increments integers by 5 starting from 2' do
      expect(data_generator.send(:sequential_number, 'example_column', 2, 5)).to eq(2)
      expect(data_generator.send(:sequential_number, 'example_column', 2, 5)).to eq(7)
    end
  end
end
