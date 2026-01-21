# frozen_string_literal: true

RSpec.describe Yamlint::Rules::Indentation do
  describe 'with 2 spaces' do
    let(:rule) { described_class.new({ spaces: 2 }) }

    it 'accepts correct indentation' do
      context = build_context("key:\n  nested: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'detects wrong indentation' do
      context = build_context("key:\n   nested: value\n")
      problems = rule.check(context)

      expect(problems.map(&:line)).to eq([2])
    end

    it 'accepts no indentation' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'accepts multiple levels' do
      context = build_context("key:\n  nested:\n    deep: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with 4 spaces' do
    let(:rule) { described_class.new({ spaces: 4 }) }

    it 'accepts correct 4-space indentation' do
      context = build_context("key:\n    nested: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'detects 2-space indentation' do
      context = build_context("key:\n  nested: value\n")
      problems = rule.check(context)

      expect(problems.size).to eq(1)
    end
  end

  describe 'ignoring comments and empty lines' do
    let(:rule) { described_class.new({ spaces: 2 }) }

    it 'ignores comment lines' do
      context = build_context("# comment at start\nkey: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'ignores empty lines' do
      context = build_context("key: value\n\nother: data\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe '#fixable?' do
    let(:rule) { described_class.new }

    it 'returns true' do
      expect(rule.fixable?).to be(true)
    end
  end
end
