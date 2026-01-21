# frozen_string_literal: true

RSpec.describe Yamlint do
  it 'has a version number' do
    expect(Yamlint::VERSION).not_to be_nil
  end

  describe Yamlint::Linter do
    let(:linter) { described_class.new(default_config) }

    describe '#lint' do
      it 'returns no problems for valid YAML' do
        content = "key: value\n"
        problems = linter.lint(content)
        expect(problems).to be_empty
      end

      it 'detects trailing spaces' do
        content = "key: value   \n"
        problems = linter.lint(content)
        expect(problems.map(&:rule)).to include('trailing-spaces')
      end

      it 'detects syntax errors' do
        content = "key: [\n"
        problems = linter.lint(content)
        expect(problems.map(&:rule)).to include('syntax')
      end
    end
  end

  describe Yamlint::Formatter do
    let(:formatter) { described_class.new }

    describe '#format' do
      it 'removes trailing spaces' do
        input = "key: value   \n"
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end

      it 'adds newline at end of file' do
        input = 'key: value'
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end

      it 'preserves YAML semantics' do
        input = "key: value   \nlist:\n  - item1  \n  - item2\n"
        output = formatter.format(input)
        expect(YAML.safe_load(output)).to eq(YAML.safe_load(input))
      end
    end
  end

  describe Yamlint::Rules do
    describe Yamlint::Rules::TrailingSpaces do
      let(:rule) { described_class.new }

      it 'detects trailing spaces' do
        context = Yamlint::Models::LintContext.new(filepath: 'test.yaml', content: "key: value   \n")
        problems = rule.check(context)
        expect(problems.length).to eq(1)
        expect(problems.first.rule).to eq('trailing-spaces')
      end

      it 'returns no problems for clean lines' do
        context = Yamlint::Models::LintContext.new(filepath: 'test.yaml', content: "key: value\n")
        problems = rule.check(context)
        expect(problems).to be_empty
      end
    end
  end
end
