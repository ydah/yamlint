# frozen_string_literal: true

RSpec.describe Yamlint::Rules::EmptyLines do
  describe 'max-start option' do
    let(:rule) { described_class.new({ 'max-start': 0, 'max-end': 0, max: 2 }) }

    it 'detects empty lines at start' do
      context = build_context("\n\nkey: value\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('beginning of file'))
    end

    it 'accepts no empty lines at start' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      start_problems = problems.select { |p| p.message.include?('beginning') }
      expect(start_problems).to be_empty
    end
  end

  describe 'max-end option' do
    let(:rule) { described_class.new({ 'max-start': 0, 'max-end': 0, max: 2 }) }

    it 'detects empty lines at end' do
      context = build_context("key: value\n\n\n")
      problems = rule.check(context)

      end_problems = problems.select { |p| p.message.include?('end of file') }
      expect(end_problems.length).to eq(1)
    end
  end

  describe 'max option' do
    let(:rule) { described_class.new({ 'max-start': 0, 'max-end': 0, max: 2 }) }

    it 'detects too many consecutive empty lines' do
      context = build_context("key1: value\n\n\n\nkey2: value\n")
      problems = rule.check(context)

      consecutive_problems = problems.select { |p| p.message.match?(/too many blank lines \(\d+ >/) }
      expect(consecutive_problems.length).to eq(1)
    end

    it 'allows up to max consecutive empty lines' do
      context = build_context("key1: value\n\n\nkey2: value\n")
      problems = rule.check(context)

      consecutive_problems = problems.select { |p| p.message.match?(/too many blank lines \(\d+ >/) }
      expect(consecutive_problems).to be_empty
    end
  end

  describe '#fixable?' do
    let(:rule) { described_class.new }

    it 'returns true' do
      expect(rule.fixable?).to be(true)
    end
  end
end
