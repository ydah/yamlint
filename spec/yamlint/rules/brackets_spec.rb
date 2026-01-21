# frozen_string_literal: true

RSpec.describe Yamlint::Rules::Brackets do
  describe 'forbid option' do
    let(:rule) { described_class.new({ forbid: true }) }

    it 'forbids flow sequences' do
      context = build_context("list: [a, b, c]\n")
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('forbidden'))
    end
  end

  describe 'min-spaces-inside' do
    let(:rule) { described_class.new({ forbid: false, 'min-spaces-inside': 1, 'max-spaces-inside': 1 }) }

    it 'detects missing space after opening bracket' do
      context = build_context("[a, b]\n")
      problems = rule.check(context)

      expect(problems.any? { |p| p.message.include?('too few spaces') }).to be(true)
    end

    it 'accepts space after opening bracket' do
      context = build_context("[ a, b ]\n")
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'max-spaces-inside' do
    let(:rule) { described_class.new({ forbid: false, 'min-spaces-inside': 0, 'max-spaces-inside': 0 }) }

    it 'detects space inside brackets' do
      context = build_context("[ a, b ]\n")
      problems = rule.check(context)

      expect(problems.any? { |p| p.message.include?('too many spaces') }).to be(true)
    end

    it 'accepts no space inside brackets' do
      context = build_context("[a, b]\n")
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
