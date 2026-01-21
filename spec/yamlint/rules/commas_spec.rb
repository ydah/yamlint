# frozen_string_literal: true

RSpec.describe Yamlint::Rules::Commas do
  describe 'max-spaces-before' do
    let(:rule) { described_class.new({ 'max-spaces-before': 0, 'min-spaces-after': 1, 'max-spaces-after': 1 }) }

    it 'detects space before comma' do
      context = build_context("[a , b]\n")
      problems = rule.check(context)

      before_problems = problems.select { |p| p.message.include?('before comma') }
      expect(before_problems.length).to eq(1)
    end

    it 'accepts no space before comma' do
      context = build_context("[a, b]\n")
      problems = rule.check(context)

      before_problems = problems.select { |p| p.message.include?('before comma') }
      expect(before_problems).to be_empty
    end
  end

  describe 'min-spaces-after' do
    let(:rule) { described_class.new({ 'max-spaces-before': 0, 'min-spaces-after': 1, 'max-spaces-after': 1 }) }

    it 'detects no space after comma' do
      context = build_context("[a,b]\n")
      problems = rule.check(context)

      after_problems = problems.select { |p| p.message.include?('too few spaces after') }
      expect(after_problems.length).to eq(1)
    end
  end

  describe 'max-spaces-after' do
    let(:rule) { described_class.new({ 'max-spaces-before': 0, 'min-spaces-after': 1, 'max-spaces-after': 1 }) }

    it 'detects too many spaces after comma' do
      context = build_context("[a,  b]\n")
      problems = rule.check(context)

      after_problems = problems.select { |p| p.message.include?('too many spaces after') }
      expect(after_problems.length).to eq(1)
    end

    it 'accepts single space after comma' do
      context = build_context("[a, b]\n")
      problems = rule.check(context)

      after_problems = problems.select { |p| p.message.include?('after comma') }
      expect(after_problems).to be_empty
    end
  end

  describe '#fixable?' do
    let(:rule) { described_class.new }

    it 'returns true' do
      expect(rule.fixable?).to be(true)
    end
  end
end
