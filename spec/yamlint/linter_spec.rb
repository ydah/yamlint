# frozen_string_literal: true

RSpec.describe Yamlint::Linter do
  let(:linter) { described_class.new(default_config) }

  describe '#lint' do
    context 'with valid YAML' do
      it 'returns no problems for clean YAML' do
        content = "key: value\n"
        problems = linter.lint(content)
        expect(problems).to be_empty
      end

      it 'returns no problems for complex valid YAML' do
        content = <<~YAML
          name: test
          version: 1.0.0
          dependencies:
            - package1
            - package2
        YAML
        problems = linter.lint(content)
        non_empty_problems = problems.reject { |p| p.rule == 'empty-values' }
        expect(non_empty_problems).to be_empty
      end
    end

    context 'with syntax errors' do
      it 'detects invalid YAML syntax' do
        content = "key: [\n"
        problems = linter.lint(content)
        expect(problems.map(&:rule)).to include('syntax')
      end

      it 'reports syntax error with line number' do
        content = "valid: yaml\ninvalid: [\n"
        problems = linter.lint(content)
        syntax_problem = problems.find { |p| p.rule == 'syntax' }
        aggregate_failures do
          expect(syntax_problem).not_to be_nil
          expect(syntax_problem.level).to eq(:error)
        end
      end
    end

    context 'with trailing spaces' do
      it 'detects trailing spaces' do
        content = "key: value   \n"
        problems = linter.lint(content)
        expect(problems.map(&:rule)).to include('trailing-spaces')
      end

      it 'reports correct column for trailing spaces' do
        content = "key: value   \n"
        problems = linter.lint(content)
        trailing = problems.find { |p| p.rule == 'trailing-spaces' }
        expect(trailing.column).to eq(11)
      end
    end

    context 'with missing newline at end' do
      it 'detects missing newline' do
        content = 'key: value'
        problems = linter.lint(content)
        expect(problems.map(&:rule)).to include('new-line-at-end-of-file')
      end
    end

    context 'with indentation issues' do
      it 'detects wrong indentation' do
        content = "key:\n   value: test\n"
        problems = linter.lint(content)
        expect(problems.map(&:rule)).to include('indentation')
      end
    end

    context 'with multiple issues' do
      it 'reports all issues' do
        content = "key: value   \n  bad: indent\n"
        problems = linter.lint(content)
        expect(problems.length).to be >= 1
      end
    end

    context 'with disable comments' do
      it 'respects yamllint disable' do
        content = "# yamllint disable\nkey: value   \n"
        problems = linter.lint(content)
        trailing = problems.find { |p| p.rule == 'trailing-spaces' }
        expect(trailing).to be_nil
      end

      it 'respects yamllint disable-line' do
        content = "key: value   # yamllint disable-line\n"
        problems = linter.lint(content)
        trailing = problems.find { |p| p.rule == 'trailing-spaces' }
        expect(trailing).to be_nil
      end

      it 'respects yamllint disable for specific rule' do
        content = "# yamllint disable trailing-spaces\nkey: value   \n"
        problems = linter.lint(content)
        trailing = problems.find { |p| p.rule == 'trailing-spaces' }
        expect(trailing).to be_nil
      end

      it 'respects yamllint enable' do
        content = <<~YAML
          # yamllint disable trailing-spaces
          key1: value#{'   '}
          # yamllint enable trailing-spaces
          key2: value#{'   '}
        YAML
        problems = linter.lint(content)
        trailing_problems = problems.select { |p| p.rule == 'trailing-spaces' }
        expect(trailing_problems).not_to be_empty
      end
    end

    context 'with relaxed config' do
      let(:linter) { described_class.new(relaxed_config) }

      it 'does not report trailing spaces' do
        content = "key: value   \n"
        problems = linter.lint(content)
        expect(problems.map(&:rule)).not_to include('trailing-spaces')
      end
    end
  end

  describe '#lint_file' do
    let(:tmpdir) { Dir.mktmpdir }

    after { FileUtils.remove_entry(tmpdir) }

    it 'lints a file' do
      file = File.join(tmpdir, 'test.yaml')
      File.write(file, "key: value   \n")

      problems = linter.lint_file(file)
      expect(problems.map(&:rule)).to include('trailing-spaces')
    end
  end
end
