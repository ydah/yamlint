# frozen_string_literal: true

RSpec.describe Yamlint::Output do
  describe '.get' do
    it 'returns Standard for standard format' do
      expect(described_class.get('standard')).to be_a(Yamlint::Output::Standard)
    end

    it 'returns Parsable for parsable format' do
      expect(described_class.get('parsable')).to be_a(Yamlint::Output::Parsable)
    end

    it 'returns Colored for colored format' do
      expect(described_class.get('colored')).to be_a(Yamlint::Output::Colored)
    end

    it 'returns Colored for auto format' do
      expect(described_class.get('auto')).to be_a(Yamlint::Output::Colored)
    end

    it 'returns Github for github format' do
      expect(described_class.get('github')).to be_a(Yamlint::Output::Github)
    end

    it 'raises error for unknown format' do
      expect do
        described_class.get('unknown')
      end.to raise_error(ArgumentError, /Unknown output format/)
    end
  end

  describe Yamlint::Output::Standard do
    let(:output) { described_class.new }
    let(:problem) do
      Yamlint::Models::Problem.new(
        line: 1, column: 5, rule: 'test-rule', level: :error, message: 'test message'
      )
    end

    describe '#format' do
      it 'returns empty string for no problems' do
        expect(output.format('test.yaml', [])).to eq('')
      end

      it 'formats problems with filepath header' do
        result = output.format('test.yaml', [problem])
        aggregate_failures do
          expect(result).to include('test.yaml')
          expect(result).to include('1:5')
          expect(result).to include('error')
          expect(result).to include('test message')
          expect(result).to include('test-rule')
        end
      end
    end

    describe '#format_summary' do
      it 'shows success message for no problems' do
        result = output.format_summary(5, 0)
        aggregate_failures do
          expect(result).to include('5 file(s) checked')
          expect(result).to include('no problems found')
        end
      end

      it 'shows problem count' do
        result = output.format_summary(5, 3)
        aggregate_failures do
          expect(result).to include('5 file(s) checked')
          expect(result).to include('3 problem(s) found')
        end
      end
    end
  end

  describe Yamlint::Output::Parsable do
    let(:output) { described_class.new }
    let(:problem) do
      Yamlint::Models::Problem.new(
        line: 1, column: 5, rule: 'test-rule', level: :error, message: 'test message'
      )
    end

    describe '#format' do
      it 'returns empty string for no problems' do
        expect(output.format('test.yaml', [])).to eq('')
      end

      it 'formats in machine-readable format' do
        result = output.format('test.yaml', [problem])
        expect(result).to eq('test.yaml:1:5: [error] test message (test-rule)')
      end

      it 'formats multiple problems on separate lines' do
        problem2 = Yamlint::Models::Problem.new(
          line: 2, column: 1, rule: 'other', level: :warning, message: 'another'
        )
        result = output.format('test.yaml', [problem, problem2])
        lines = result.split("\n")
        expect(lines.length).to eq(2)
      end
    end

    describe '#format_summary' do
      it 'returns empty string' do
        expect(output.format_summary(5, 3)).to eq('')
      end
    end
  end

  describe Yamlint::Output::Github do
    let(:output) { described_class.new }
    let(:error_problem) do
      Yamlint::Models::Problem.new(
        line: 1, column: 5, rule: 'test-rule', level: :error, message: 'test message'
      )
    end
    let(:warning_problem) do
      Yamlint::Models::Problem.new(
        line: 2, column: 1, rule: 'other', level: :warning, message: 'warning message'
      )
    end

    describe '#format' do
      it 'returns empty string for no problems' do
        expect(output.format('test.yaml', [])).to eq('')
      end

      it 'formats errors as GitHub error annotations' do
        result = output.format('test.yaml', [error_problem])
        expect(result).to eq('::error file=test.yaml,line=1,col=5::test message (test-rule)')
      end

      it 'formats warnings as GitHub warning annotations' do
        result = output.format('test.yaml', [warning_problem])
        expect(result).to eq('::warning file=test.yaml,line=2,col=1::warning message (other)')
      end
    end

    describe '#format_summary' do
      it 'returns empty string' do
        expect(output.format_summary(5, 3)).to eq('')
      end
    end
  end

  describe Yamlint::Output::Colored do
    let(:output) { described_class.new }
    let(:problem) do
      Yamlint::Models::Problem.new(
        line: 1, column: 5, rule: 'test-rule', level: :error, message: 'test message'
      )
    end

    describe '#format' do
      it 'returns empty string for no problems' do
        expect(output.format('test.yaml', [])).to eq('')
      end

      it 'includes ANSI color codes' do
        result = output.format('test.yaml', [problem])
        expect(result).to include("\e[")
      end

      it 'includes problem details' do
        result = output.format('test.yaml', [problem])
        aggregate_failures do
          expect(result).to include('1:5')
          expect(result).to include('error')
          expect(result).to include('test message')
        end
      end
    end

    describe '#format_summary' do
      it 'includes color codes' do
        result = output.format_summary(5, 0)
        expect(result).to include("\e[")
      end
    end
  end
end
