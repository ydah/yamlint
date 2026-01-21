# frozen_string_literal: true

RSpec.describe Yamlint::Rules::Colons do
  describe 'max-spaces-before' do
    let(:rule) { described_class.new({ 'max-spaces-before': 0, 'max-spaces-after': 1 }) }

    it 'detects spaces before colon' do
      context = build_context("key : value\n")
      problems = rule.check(context)

      before_problems = problems.select { |p| p.message.include?('before colon') }
      expect(before_problems.length).to eq(1)
    end

    it 'accepts no space before colon' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      before_problems = problems.select { |p| p.message.include?('before colon') }
      expect(before_problems).to be_empty
    end
  end

  describe 'max-spaces-after' do
    let(:rule) { described_class.new({ 'max-spaces-before': 0, 'max-spaces-after': 1 }) }

    it 'detects too many spaces after colon' do
      context = build_context("key:  value\n")
      problems = rule.check(context)

      after_problems = problems.select { |p| p.message.include?('after colon') }
      expect(after_problems.length).to eq(1)
    end

    it 'accepts single space after colon' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      after_problems = problems.select { |p| p.message.include?('after colon') }
      expect(after_problems).to be_empty
    end
  end

  describe 'ignoring comments and empty lines' do
    let(:rule) { described_class.new }

    it 'ignores comment lines' do
      context = build_context("# comment:  here\nkey: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'ignores empty lines' do
      context = build_context("\nkey: value\n")
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
