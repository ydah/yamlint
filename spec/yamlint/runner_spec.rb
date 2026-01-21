# frozen_string_literal: true

RSpec.describe Yamlint::Runner do
  let(:runner) { described_class.new(config: default_config, output_format: 'standard') }

  describe '#lint' do
    let(:tmpdir) { Dir.mktmpdir }

    after { FileUtils.remove_entry(tmpdir) }

    it 'lints files in a directory' do
      File.write(File.join(tmpdir, 'test.yaml'), "key: value\n")
      File.write(File.join(tmpdir, 'test2.yml'), "other: value\n")

      result = runner.lint([tmpdir])

      expect(result).to include(files: 2, exit_code: 0)
    end

    it 'finds problems in files' do
      File.write(File.join(tmpdir, 'test.yaml'), "key: value   \n")

      result = runner.lint([tmpdir])

      expect(result).to include(problems: be_positive, exit_code: 1)
    end

    it 'lints specific files' do
      file = File.join(tmpdir, 'test.yaml')
      File.write(file, "key: value\n")

      result = runner.lint([file])

      expect(result[:files]).to eq(1)
    end

    it 'includes summary' do
      file = File.join(tmpdir, 'test.yaml')
      File.write(file, "key: value\n")

      result = runner.lint([file])

      expect(result[:summary]).to include('1 file(s) checked')
    end
  end

  describe '#format' do
    let(:tmpdir) { Dir.mktmpdir }

    after { FileUtils.remove_entry(tmpdir) }

    it 'formats files in a directory' do
      File.write(File.join(tmpdir, 'test.yaml'), "key: value   \n")

      result = runner.format([tmpdir])

      expect(result).to include(files: 1, changed: 1, exit_code: 0)
    end

    it 'reports unchanged files' do
      File.write(File.join(tmpdir, 'test.yaml'), "key: value\n")

      result = runner.format([tmpdir])

      expect(result[:changed]).to eq(0)
    end
  end
end
