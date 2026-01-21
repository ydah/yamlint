# frozen_string_literal: true

RSpec.describe Yamlint::Rules do
  describe Yamlint::Rules::Base do
    describe 'class methods' do
      before do
        stub_const('TestRule', Class.new(described_class) do
          rule_id 'test-rule'
          desc 'A test rule'
          defaults({ option: 'value' })
        end)
      end

      describe '.rule_id' do
        it 'sets the rule id' do
          expect(TestRule.id).to eq('test-rule')
        end
      end

      describe '.desc' do
        it 'sets the description' do
          expect(TestRule.description).to eq('A test rule')
        end
      end

      describe '.defaults' do
        it 'sets default options' do
          expect(TestRule.default_options).to eq({ option: 'value' })
        end
      end
    end

    describe '#initialize' do
      before do
        stub_const('TestRule', Class.new(described_class) do
          rule_id 'test-rule'
          defaults({ option1: 'default', option2: 'default2' })
        end)
      end

      it 'merges config with defaults' do
        rule = TestRule.new({ option1: 'custom' })
        expect(rule.config).to include(option1: 'custom', option2: 'default2')
      end

      it 'sets default level to error' do
        rule = TestRule.new
        expect(rule.level).to eq(:error)
      end

      it 'allows custom level' do
        rule = TestRule.new({ level: :warning })
        expect(rule.level).to eq(:warning)
      end
    end

    describe '#check' do
      it 'raises NotImplementedError' do
        rule = described_class.new
        context = build_context("key: value\n")
        expect { rule.check(context) }.to raise_error(NotImplementedError)
      end
    end

    describe '#fixable?' do
      it 'returns false by default' do
        rule = described_class.new
        expect(rule.fixable?).to be(false)
      end
    end
  end

  describe Yamlint::Rules::LineRule do
    describe '#check' do
      before do
        stub_const('TestLineRule', Class.new(described_class) do
          rule_id 'test-line-rule'

          def check_line(line, line_number, _context)
            return nil unless line.include?('bad')

            problem(line: line_number, column: 1, message: 'found bad')
          end
        end)
      end

      it 'calls check_line for each line' do
        rule = TestLineRule.new
        context = build_context("good\nbad\ngood\n")
        problems = rule.check(context)

        expect(problems.map(&:line)).to eq([2])
      end
    end

    describe '#check_line' do
      it 'raises NotImplementedError' do
        rule = described_class.new
        expect { rule.check_line('line', 1, nil) }.to raise_error(NotImplementedError)
      end
    end
  end

  describe Yamlint::Rules::TokenRule do
    describe '#check_token' do
      it 'raises NotImplementedError' do
        rule = described_class.new
        expect { rule.check_token(nil, nil) }.to raise_error(NotImplementedError)
      end
    end
  end

  describe Yamlint::Rules::CommentRule do
    describe '#check_comment' do
      it 'raises NotImplementedError' do
        rule = described_class.new
        expect { rule.check_comment(nil, nil) }.to raise_error(NotImplementedError)
      end
    end
  end
end
