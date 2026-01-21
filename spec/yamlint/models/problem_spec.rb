# frozen_string_literal: true

RSpec.describe Yamlint::Models::Problem do
  describe '#initialize' do
    it 'creates a problem with all attributes' do
      problem = described_class.new(
        line: 1,
        column: 5,
        rule: 'test-rule',
        level: :error,
        message: 'test message',
        fixable: true
      )

      expect(problem).to have_attributes(
        line: 1,
        column: 5,
        rule: 'test-rule',
        level: :error,
        message: 'test message',
        fixable: true
      )
    end

    it 'defaults fixable to false' do
      problem = described_class.new(
        line: 1,
        column: 1,
        rule: 'test',
        level: :warning,
        message: 'msg'
      )

      expect(problem.fixable).to be(false)
    end

    it 'raises error for invalid level' do
      expect do
        described_class.new(
          line: 1,
          column: 1,
          rule: 'test',
          level: :invalid,
          message: 'msg'
        )
      end.to raise_error(ArgumentError, /Invalid level/)
    end
  end

  describe '#error?' do
    it 'returns true for error level' do
      problem = described_class.new(line: 1, column: 1, rule: 'test', level: :error, message: 'msg')
      expect(problem.error?).to be(true)
    end

    it 'returns false for warning level' do
      problem = described_class.new(line: 1, column: 1, rule: 'test', level: :warning, message: 'msg')
      expect(problem.error?).to be(false)
    end
  end

  describe '#warning?' do
    it 'returns true for warning level' do
      problem = described_class.new(line: 1, column: 1, rule: 'test', level: :warning, message: 'msg')
      expect(problem.warning?).to be(true)
    end

    it 'returns false for error level' do
      problem = described_class.new(line: 1, column: 1, rule: 'test', level: :error, message: 'msg')
      expect(problem.warning?).to be(false)
    end
  end

  describe '#fixable?' do
    it 'returns true when fixable' do
      problem = described_class.new(line: 1, column: 1, rule: 'test', level: :error, message: 'msg', fixable: true)
      expect(problem.fixable?).to be(true)
    end

    it 'returns false when not fixable' do
      problem = described_class.new(line: 1, column: 1, rule: 'test', level: :error, message: 'msg', fixable: false)
      expect(problem.fixable?).to be(false)
    end
  end

  describe '#to_s' do
    it 'returns formatted string' do
      problem = described_class.new(line: 10, column: 5, rule: 'test-rule', level: :error, message: 'test message')
      expect(problem.to_s).to eq('10:5 [error] test message (test-rule)')
    end
  end
end
