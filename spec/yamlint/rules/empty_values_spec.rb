# frozen_string_literal: true

RSpec.describe Yamlint::Rules::EmptyValues do
  describe 'forbid-in-block-mappings' do
    let(:rule) { described_class.new({ 'forbid-in-block-mappings': true, 'forbid-in-flow-mappings': true }) }

    it 'detects empty value in block mapping' do
      context = build_context("key:\nother: value\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('empty value in block mapping'))
    end

    it 'accepts non-empty values' do
      context = build_context("key: value\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'allows multiline values with pipe' do
      context = build_context("key: |\n  multiline\n  content\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'allows multiline values with greater-than' do
      context = build_context("key: >\n  folded\n  content\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'forbid-in-flow-mappings' do
    let(:rule) { described_class.new({ 'forbid-in-block-mappings': false, 'forbid-in-flow-mappings': true }) }

    it 'detects empty value in flow mapping' do
      context = build_context("{key:, other: value}\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('empty value in flow mapping'))
    end

    it 'accepts non-empty flow values' do
      context = build_context("{key: value}\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end
end
