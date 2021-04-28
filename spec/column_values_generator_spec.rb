require_relative '../column_values_generator'

describe 'ColumnValuesGenerator' do
  let(:generator) { ColumnValuesGenerator.new(3) }
  let(:random_string_regex) { /^'\w{5}'$/ }
  let(:sequential_numbers) { [5, 15, 25] }
  let(:sequential_dates) { ["'2021-04-20'", "'2021-04-21'", "'2021-04-22'"] }

  describe '#generate' do
    let(:generated_column_values) { generator.generate(column) }

    context 'when column is random strings' do
      let(:column) {
        { 'data_type' => 'string', 'value_type' => 'random', 'length' => 5 }
      }

      it 'generates random strings of length 5' do
        expect(generated_column_values).to all(match(random_string_regex))
      end
      it 'generates 3 values' do
        expect(generated_column_values.count).to eq(3)
      end
    end

    context 'when column is random numbers' do
      let(:column) {
        { 'data_type' => 'number', 'value_type' => 'random', 'range' => [5, 10] }
      }

      it 'generates random numbers between 5 and 10' do
        expect(generated_column_values).to all(be_between(5, 10))
      end
    end

    context 'when column is sequential numbers' do
      let(:column) {
        { 'data_type' => 'number', 'value_type' => 'sequential', 'start' => 5, 'increment' => 10 }
      }

      it 'generates numbers starting from 5 incrementing by 10' do
        expect(generated_column_values).to eq(sequential_numbers)
      end
    end

    context 'when column is sequential dates' do
      let(:column) {
        { 'data_type' => 'date', 'value_type' => 'sequential', 'start' => '2021-04-20', 'day_increment' => 1 }
      }

      it "generates dates starting from '2021-04-20' incrementing by 1 day" do
        expect(generated_column_values).to eq(sequential_dates)
      end
    end
  end

  describe '#random_strings' do
    it 'generates random strings of length 5' do
      expect(generator.send(:random_strings, length: 5)).to all(match(random_string_regex))
    end
  end

  describe '#random_numbers' do
    it 'generates random numbers between 5 and 10' do
      expect(generator.send(:random_numbers, range: [5, 10])).to all(be_between(5, 10))
    end
  end

  describe '#sequential_numbers' do
    it 'generates sequential numbers starting from 5 and incrementing by 10' do
      expect(generator.send(:sequential_numbers, start: 5, increment: 10)).to eq(sequential_numbers)
    end
  end

  describe '#sequential dates' do
    it "generates sequential dates starting from '2021-04-20' and incrementing by 1 day" do
      expect(generator.send(:sequential_dates, start: '2021-04-20', day_increment: 1))
        .to eq(sequential_dates)
    end
  end
end
