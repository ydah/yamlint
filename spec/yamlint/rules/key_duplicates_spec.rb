# frozen_string_literal: true

RSpec.describe Yamlint::Rules::KeyDuplicates do
  let(:rule) { described_class.new }

  describe '#check' do
    it 'detects duplicate keys' do
      content = "key: value1\nkey: value2\n"
      context = build_context(content)
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('duplicate key'))
    end

    it 'accepts unique keys' do
      content = <<~YAML
        key1: value1
        key2: value2
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'detects duplicates in nested mappings' do
      content = "parent:\n  child: value1\n  child: value2\n"
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).not_to be_empty
    end

    it 'allows same key name in different mappings' do
      content = <<~YAML
        parent1:
          key: value1
        parent2:
          key: value2
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'handles invalid YAML gracefully' do
      content = "key: [\n"
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_an(Array)
    end
  end
end
