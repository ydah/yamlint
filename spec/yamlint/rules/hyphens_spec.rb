# frozen_string_literal: true

RSpec.describe Yamlint::Rules::Hyphens do
  describe 'max-spaces-after' do
    let(:rule) { described_class.new({ 'max-spaces-after': 1 }) }

    it 'detects too many spaces after hyphen' do
      context = build_context("-  item\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('after hyphen'))
    end

    it 'accepts single space after hyphen' do
      context = build_context("- item\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'checks multiple list items' do
      context = build_context("- item1\n-  item2\n- item3\n")
      problems = rule.check(context)

      expect(problems.map(&:line)).to eq([2])
    end

    it 'handles indented lists' do
      context = build_context("list:\n  -  item\n")
      problems = rule.check(context)

      expect(problems.size).to eq(1)
    end
  end

  describe '#fixable?' do
    let(:rule) { described_class.new }

    it 'returns true' do
      expect(rule.fixable?).to be(true)
    end
  end
end
