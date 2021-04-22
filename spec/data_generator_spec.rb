require_relative '../data_generator'

describe 'DataGenerator' do
  subject(:data_generator) { DataGenerator.new }

  describe '#generate' do
    context 'when value_type is random-string' do
      it 'generates a string' do
        expect(data_generator.generate('random-string')).to be_an_instance_of(String)
      end
    end

    context 'when value_type is undefined' do
      it 'raises UndefinedValueTypeError' do
        expect { data_generator.generate('undefined') }.to raise_error(UndefinedValueTypeError)
      end
    end
  end

  describe '#random_string' do
    it 'generates a string of length 10 that has only letters and numbers' do
      expect(data_generator.random_string).to match(/^'\w{10}'$/)
    end
  end

  describe '#sequential_integer' do
    subject(:data_generator) { DataGenerator.new }

    it 'generates integers in sequence starting from 0' do
      expect(data_generator.sequential_integer).to eq(0)
      expect(data_generator.sequential_integer).to eq(1)
    end
  end
end
