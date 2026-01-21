# frozen_string_literal: true

RSpec.describe Yamlint::Rules::NewLines do
  describe 'with unix type' do
    let(:rule) { described_class.new({ type: 'unix' }) }

    it 'detects CRLF line endings' do
      context = build_context("key: value\r\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('expected unix'))
    end

    it 'accepts LF line endings' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with dos type' do
    let(:rule) { described_class.new({ type: 'dos' }) }

    it 'detects LF-only line endings' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('expected dos'))
    end

    it 'accepts CRLF line endings' do
      context = build_context("key: value\r\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with platform type' do
    let(:rule) { described_class.new({ type: 'platform' }) }

    it 'accepts any line ending' do
      context1 = build_context("key: value\n")
      context2 = build_context("key: value\r\n")

      expect(rule.check(context1)).to be_empty
      expect(rule.check(context2)).to be_empty
    end
  end

  describe '#fixable?' do
    let(:rule) { described_class.new }

    it 'returns true' do
      expect(rule.fixable?).to be(true)
    end
  end
end
