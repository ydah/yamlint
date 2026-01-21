# frozen_string_literal: true

RSpec.describe Yamlint::Rules::QuotedStrings do
  describe 'with quote-type: single' do
    let(:rule) { described_class.new({ 'quote-type': 'single', required: true }) }

    it 'detects double-quoted strings' do
      context = build_context("key: \"value\"\n")
      problems = rule.check(context)

      quote_problems = problems.select { |p| p.message.include?('quote type') }
      expect(quote_problems.map(&:message)).to include(a_string_including('expected single'))
    end

    it 'accepts single-quoted strings' do
      context = build_context("key: 'value'\n")
      problems = rule.check(context)

      quote_problems = problems.select { |p| p.message.include?('quote type') }
      expect(quote_problems).to be_empty
    end
  end

  describe 'with quote-type: double' do
    let(:rule) { described_class.new({ 'quote-type': 'double', required: true }) }

    it 'detects single-quoted strings' do
      context = build_context("key: 'value'\n")
      problems = rule.check(context)

      quote_problems = problems.select { |p| p.message.include?('quote type') }
      expect(quote_problems.map(&:message)).to include(a_string_including('expected double'))
    end
  end

  describe 'with required: false' do
    let(:rule) { described_class.new({ required: false }) }

    it 'does not require quoting' do
      context = build_context("key: value\n")
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
