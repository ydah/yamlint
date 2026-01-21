# frozen_string_literal: true

RSpec.describe Yamlint::Rules::KeyOrdering do
  let(:rule) { described_class.new }

  describe '#check' do
    it 'detects out-of-order keys' do
      content = "bravo: 2\nalpha: 1\n"
      context = build_context(content)
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('wrong ordering'))
    end

    it 'accepts alphabetically ordered keys' do
      content = <<~YAML
        alpha: 1
        bravo: 2
        charlie: 3
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'checks nested mappings independently' do
      content = "parent1:\n  zebra: last\n  alpha: first\nparent2:\n  alpha: first\n"
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).not_to be_empty
    end

    it 'handles invalid YAML gracefully' do
      content = "key: [\n"
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_an(Array)
    end
  end
end
