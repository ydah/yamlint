# frozen_string_literal: true

RSpec.describe Yamlint::Parser::LineParser do
  let(:content) { "line1\nline2\nline3\n" }
  let(:parser) { described_class.new(content) }

  describe '#parse' do
    it 'returns array of lines' do
      expect(parser.parse).to eq(%W[line1\n line2\n line3\n])
    end

    it 'handles empty content' do
      empty_parser = described_class.new('')
      expect(empty_parser.parse).to eq([])
    end

    it 'handles content without trailing newline' do
      no_newline = described_class.new("line1\nline2")
      expect(no_newline.parse).to eq(%W[line1\n line2])
    end
  end

  describe '#line_at' do
    it 'returns line at 1-indexed position' do
      expect([parser.line_at(1), parser.line_at(2), parser.line_at(3)]).to eq(%W[
                                                                                line1\n
                                                                                line2\n
                                                                                line3\n
                                                                              ])
    end

    it 'returns nil for out of range' do
      expect(parser.line_at(10)).to be_nil
    end
  end

  describe '#line_count' do
    it 'returns number of lines' do
      expect(parser.line_count).to eq(3)
    end

    it 'returns 0 for empty content' do
      empty_parser = described_class.new('')
      expect(empty_parser.line_count).to eq(0)
    end
  end

  describe '#each_line_with_number' do
    it 'yields each line with 1-indexed line number' do
      results = []
      parser.each_line_with_number do |line, number|
        results << [line, number]
      end

      expect(results).to eq([
                              ["line1\n", 1],
                              ["line2\n", 2],
                              ["line3\n", 3]
                            ])
    end
  end
end
