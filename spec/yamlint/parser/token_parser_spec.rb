# frozen_string_literal: true

RSpec.describe Yamlint::Parser::TokenParser do
  describe '#parse' do
    it 'parses simple YAML and returns tokens' do
      content = "key: value\n"
      parser = described_class.new(content)
      tokens = parser.parse

      types = tokens.map(&:type)
      expect(types).to include(:stream_start, :document_start, :scalar)
    end

    it 'parses mapping tokens' do
      content = "foo: bar\nbaz: qux\n"
      parser = described_class.new(content)
      tokens = parser.parse

      types = tokens.map(&:type)
      expect(types).to include(:mapping_start, :mapping_end)
    end

    it 'parses sequence tokens' do
      content = "- item1\n- item2\n"
      parser = described_class.new(content)
      tokens = parser.parse

      types = tokens.map(&:type)
      expect(types).to include(:sequence_start, :sequence_end)
    end

    it 'handles invalid YAML gracefully' do
      content = "key: [\n"
      parser = described_class.new(content)
      tokens = parser.parse

      expect(tokens).to be_an(Array)
    end

    it 'captures scalar values' do
      content = "key: value\n"
      parser = described_class.new(content)
      tokens = parser.parse

      scalar_tokens = tokens.select { |t| t.type == :scalar }
      values = scalar_tokens.map(&:value)
      expect(values).to include('key', 'value')
    end

    it 'captures line and column information' do
      content = "key: value\n"
      parser = described_class.new(content)
      tokens = parser.parse

      expect(tokens.all? { |token| token.start_line >= 1 && token.start_column >= 1 }).to be(true)
    end
  end
end
