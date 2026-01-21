# frozen_string_literal: true

RSpec.describe Yamlint::Rules::NewLineAtEndOfFile do
  let(:rule) { described_class.new }

  describe '#check' do
    it 'detects missing newline at end' do
      context = build_context('key: value')
      problems = rule.check(context)

      expect(problems.map(&:rule)).to include('new-line-at-end-of-file')
    end

    it 'returns no problems when newline exists' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'handles empty content' do
      context = build_context('')
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'reports correct line number' do
      context = build_context("line1\nline2\nline3")
      problems = rule.check(context)

      expect(problems.first.line).to eq(3)
    end
  end

  describe '#fixable?' do
    it 'returns true' do
      expect(rule.fixable?).to be(true)
    end
  end
end
