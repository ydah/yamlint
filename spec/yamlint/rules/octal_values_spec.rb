# frozen_string_literal: true

RSpec.describe Yamlint::Rules::OctalValues do
  describe 'forbid-implicit-octal' do
    let(:rule) { described_class.new({ 'forbid-implicit-octal': true, 'forbid-explicit-octal': false }) }

    it 'detects implicit octal values' do
      context = build_context("key: 0777\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('implicit octal'))
    end

    it 'accepts non-octal numbers' do
      context = build_context("key: 123\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'allows explicit octal when only implicit is forbidden' do
      context = build_context("key: 0o777\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'forbid-explicit-octal' do
    let(:rule) { described_class.new({ 'forbid-implicit-octal': false, 'forbid-explicit-octal': true }) }

    it 'detects explicit octal values' do
      context = build_context("key: 0o755\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('explicit octal'))
    end

    it 'allows implicit octal when only explicit is forbidden' do
      context = build_context("key: 0777\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end
end
