# frozen_string_literal: true

RSpec.describe Yamlint::Rules::TrailingSpaces do
  let(:rule) { described_class.new }

  describe '#check' do
    it 'detects trailing spaces' do
      context = build_context("key: value   \n")
      problems = rule.check(context)

      expect(problems).to match([
                                  have_attributes(line: 1, column: 11, rule: 'trailing-spaces')
                                ])
    end

    it 'detects trailing tabs' do
      context = build_context("key: value\t\n")
      problems = rule.check(context)

      expect(problems.length).to eq(1)
    end

    it 'returns no problems for clean lines' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'ignores blank lines' do
      context = build_context("key: value\n\nother: data\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'checks multiple lines' do
      context = build_context("line1   \nline2\nline3   \n")
      problems = rule.check(context)

      expect(problems.map(&:line)).to eq([1, 3])
    end
  end

  describe '#fixable?' do
    it 'returns true' do
      expect(rule.fixable?).to be(true)
    end
  end
end
