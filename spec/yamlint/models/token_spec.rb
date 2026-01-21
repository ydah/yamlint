# frozen_string_literal: true

RSpec.describe Yamlint::Models::Token do
  describe '#initialize' do
    it 'creates a token with all attributes' do
      token = described_class.new(
        type: :scalar,
        value: 'test',
        start_line: 1,
        start_column: 5,
        end_line: 1,
        end_column: 9
      )

      expect(token).to have_attributes(
        type: :scalar,
        value: 'test',
        start_line: 1,
        start_column: 5,
        end_line: 1,
        end_column: 9
      )
    end

    it 'defaults end positions to start positions' do
      token = described_class.new(
        type: :mapping_start,
        start_line: 2,
        start_column: 3
      )

      expect(token).to have_attributes(end_line: 2, end_column: 3)
    end

    it 'allows nil value' do
      token = described_class.new(
        type: :stream_start,
        start_line: 1,
        start_column: 1
      )

      expect(token.value).to be_nil
    end
  end

  describe '#to_s' do
    it 'returns formatted string' do
      token = described_class.new(type: :scalar, start_line: 5, start_column: 10)
      expect(token.to_s).to eq('scalar(5:10)')
    end
  end
end
