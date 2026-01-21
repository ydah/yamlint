# frozen_string_literal: true

RSpec.describe Yamlint::Formatter do
  let(:formatter) { described_class.new }

  describe '#format' do
    context 'with trailing spaces' do
      it 'removes trailing spaces' do
        input = "key: value   \n"
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end

      it 'removes trailing tabs' do
        input = "key: value\t\t\n"
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end

      it 'removes mixed trailing whitespace' do
        input = "key: value  \t  \n"
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end
    end

    context 'with newline at end of file' do
      it 'adds missing newline' do
        input = 'key: value'
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end

      it 'preserves existing newline' do
        input = "key: value\n"
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end

      it 'does not add newline to empty content' do
        input = ''
        output = formatter.format(input)
        expect(output).to eq('')
      end
    end

    context 'with line endings' do
      it 'converts CRLF to LF by default' do
        input = "key: value\r\n"
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end
    end

    context 'with empty lines' do
      it 'removes leading empty lines' do
        input = "\n\nkey: value\n"
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end

      it 'removes trailing empty lines' do
        input = "key: value\n\n\n"
        output = formatter.format(input)
        expect(output).to eq("key: value\n")
      end

      it 'limits consecutive empty lines' do
        input = "key1: value\n\n\n\n\nkey2: value\n"
        output = formatter.format(input)
        lines = output.lines
        consecutive_empty = 0
        max_consecutive = 0
        lines.each do |line|
          if line.strip.empty?
            consecutive_empty += 1
            max_consecutive = [max_consecutive, consecutive_empty].max
          else
            consecutive_empty = 0
          end
        end
        expect(max_consecutive).to be <= 2
      end
    end

    context 'when preserving YAML semantics' do
      it 'preserves data integrity' do
        input = "key: value   \nlist:\n  - item1  \n  - item2\n"
        output = formatter.format(input)
        expect(YAML.safe_load(output)).to eq(YAML.safe_load(input))
      end

      it 'preserves complex structures' do
        input = <<~YAML
          name: test#{'   '}
          config:
            nested:
              deep: value#{'   '}
        YAML
        output = formatter.format(input)
        expect(YAML.safe_load(output)).to eq(YAML.safe_load(input))
      end
    end

    context 'with dry run mode' do
      it 'does not modify content in dry run' do
        input = "key: value   \n"
        output = formatter.format(input, dry_run: true)
        expect(output).to eq(input)
      end
    end
  end

  describe '#format_file' do
    let(:tmpdir) { Dir.mktmpdir }

    after { FileUtils.remove_entry(tmpdir) }

    it 'formats and writes file' do
      file = File.join(tmpdir, 'test.yaml')
      File.write(file, "key: value   \n")

      formatter.format_file(file)

      expect(File.read(file)).to eq("key: value\n")
    end

    it 'does not write in dry run mode' do
      file = File.join(tmpdir, 'test.yaml')
      original = "key: value   \n"
      File.write(file, original)

      formatter.format_file(file, dry_run: true)

      expect(File.read(file)).to eq(original)
    end

    it 'returns formatted content' do
      file = File.join(tmpdir, 'test.yaml')
      File.write(file, "key: value   \n")

      result = formatter.format_file(file)

      expect(result).to eq("key: value\n")
    end
  end
end
