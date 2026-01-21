# frozen_string_literal: true

RSpec.describe Yamlint::Rules::FloatValues do
  describe 'forbid-scientific-notation' do
    let(:rule) { described_class.new({ 'forbid-scientific-notation': true }) }

    it 'detects scientific notation' do
      context = build_context("key: 1.0e10\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('scientific notation'))
    end

    it 'accepts regular floats' do
      context = build_context("key: 1.5\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'forbid-nan' do
    let(:rule) { described_class.new({ 'forbid-nan': true }) }

    it 'detects .nan value' do
      context = build_context("key: .nan\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('.nan'))
    end
  end

  describe 'forbid-inf' do
    let(:rule) { described_class.new({ 'forbid-inf': true }) }

    it 'detects .inf value' do
      context = build_context("key: .inf\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('.inf'))
    end

    it 'detects negative .inf' do
      context = build_context("key: -.inf\n")
      problems = rule.check(context)

      expect(problems.length).to eq(1)
    end
  end

  describe 'require-numeral-before-decimal' do
    let(:rule) { described_class.new({ 'require-numeral-before-decimal': true }) }

    it 'detects missing numeral before decimal' do
      context = build_context("key: .5\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('numeral required'))
    end

    it 'accepts numeral before decimal' do
      context = build_context("key: 0.5\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end
end
