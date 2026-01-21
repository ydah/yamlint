# frozen_string_literal: true

RSpec.describe Yamlint::Rules::DocumentEnd do
  describe 'with present: true' do
    let(:rule) { described_class.new({ present: true }) }

    it 'detects missing document end marker' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('missing document end'))
    end

    it 'accepts document with end marker' do
      context = build_context("key: value\n...\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with present: false' do
    let(:rule) { described_class.new({ present: false }) }

    it 'detects forbidden document end marker' do
      context = build_context("key: value\n...\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('forbidden document end'))
    end

    it 'accepts document without end marker' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with empty content' do
    let(:rule) { described_class.new({ present: true }) }

    it 'returns no problems' do
      context = build_context('')
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
