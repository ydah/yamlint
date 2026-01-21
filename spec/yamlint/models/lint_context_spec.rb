# frozen_string_literal: true

RSpec.describe Yamlint::Models::LintContext do
  let(:content) { "key: value\nlist:\n  - item\n" }
  let(:context) { described_class.new(filepath: 'test.yaml', content:) }

  describe '#initialize' do
    it 'sets filepath' do
      expect(context.filepath).to eq('test.yaml')
    end

    it 'sets content' do
      expect(context.content).to eq(content)
    end

    it 'splits content into lines' do
      expect(context.lines).to eq(["key: value\n", "list:\n", "  - item\n"])
    end

    it 'initializes empty tokens' do
      expect(context.tokens).to eq([])
    end

    it 'initializes empty comments' do
      expect(context.comments).to eq([])
    end

    it 'initializes empty problems' do
      expect(context.problems).to eq([])
    end
  end

  describe '#add_problem' do
    it 'adds problem to problems list' do
      problem = Yamlint::Models::Problem.new(
        line: 1, column: 1, rule: 'test', level: :error, message: 'msg'
      )
      context.add_problem(problem)
      expect(context.problems).to include(problem)
    end
  end

  describe '#add_token' do
    it 'adds token to tokens list' do
      token = Yamlint::Models::Token.new(type: :scalar, start_line: 1, start_column: 1)
      context.add_token(token)
      expect(context.tokens).to include(token)
    end
  end

  describe '#add_comment' do
    it 'adds comment to comments list' do
      comment = Yamlint::Parser::Comment.new(line_number: 1, column: 1, text: 'test')
      context.add_comment(comment)
      expect(context.comments).to include(comment)
    end
  end

  describe '#line_count' do
    it 'returns number of lines' do
      expect(context.line_count).to eq(3)
    end
  end

  describe '#line_at' do
    it 'returns line at given line number (1-indexed)' do
      expect([context.line_at(1), context.line_at(2), context.line_at(3)]).to eq([
                                                                                   "key: value\n",
                                                                                   "list:\n",
                                                                                   "  - item\n"
                                                                                 ])
    end

    it 'returns nil for out of range line number' do
      expect(context.line_at(10)).to be_nil
    end
  end

  describe '#empty?' do
    it 'returns false for non-empty content' do
      expect(context.empty?).to be(false)
    end

    it 'returns true for empty content' do
      empty_context = described_class.new(filepath: 'empty.yaml', content: '')
      expect(empty_context.empty?).to be(true)
    end
  end
end
