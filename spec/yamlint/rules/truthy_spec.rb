# frozen_string_literal: true

RSpec.describe Yamlint::Rules::Truthy do
  describe 'with default allowed values' do
    let(:rule) { described_class.new({ 'allowed-values': %w[true false] }) }

    it 'detects YES as truthy' do
      context = build_context("key: YES\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('truthy value'))
    end

    it 'detects yes as truthy' do
      context = build_context("key: yes\n")
      problems = rule.check(context)

      expect(problems.length).to eq(1)
    end

    it 'detects NO as truthy' do
      context = build_context("key: NO\n")
      problems = rule.check(context)

      expect(problems.length).to eq(1)
    end

    it 'detects On/Off as truthy' do
      context = build_context("key1: On\nkey2: Off\n")
      problems = rule.check(context)

      expect(problems.length).to eq(2)
    end

    it 'accepts true' do
      context = build_context("key: true\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'accepts false' do
      context = build_context("key: false\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with custom allowed values' do
    let(:rule) { described_class.new({ 'allowed-values': %w[true false yes no] }) }

    it 'accepts yes when allowed' do
      context = build_context("key: yes\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end
end
