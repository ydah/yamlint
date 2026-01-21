# frozen_string_literal: true

RSpec.describe Yamlint::Rules::LineLength do
  describe 'with default max' do
    let(:rule) { described_class.new({ max: 80, 'allow-non-breakable-words': false }) }

    it 'detects lines exceeding max length' do
      long_line = "key: #{'a' * 100}"
      context = build_context("#{long_line}\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('> 80'))
    end

    it 'accepts lines at max length' do
      exact_line = 'a' * 80
      context = build_context("#{exact_line}\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'accepts lines under max length' do
      context = build_context("short line\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with custom max' do
    let(:rule) { described_class.new({ max: 120 }) }

    it 'uses custom max length' do
      line = 'a' * 100
      context = build_context("#{line}\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with allow-non-breakable-words' do
    let(:rule) { described_class.new({ max: 80, 'allow-non-breakable-words': true }) }

    it 'allows URLs longer than max' do
      url = "https://example.com/#{'a' * 100}"
      context = build_context("link: #{url}\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with allow-non-breakable-inline-mappings' do
    let(:rule) { described_class.new({ max: 80, 'allow-non-breakable-inline-mappings': true }) }

    it 'allows inline mappings longer than max' do
      mapping = "{ #{'key: value, ' * 10} }"
      context = build_context("#{mapping}\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end
end
