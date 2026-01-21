# frozen_string_literal: true

RSpec.describe Yamlint::Cli do
  describe '#run' do
    context 'with version command' do
      it 'outputs version' do
        cli = described_class.new(['version'])
        expect { cli.run }.to output(/yamlint \d+\.\d+\.\d+/).to_stdout
      end

      it 'returns exit code 0' do
        cli = described_class.new(['version'])
        expect(cli.run).to eq(0)
      end
    end

    context 'with help command' do
      it 'outputs help text' do
        cli = described_class.new(['help'])
        expect { cli.run }.to output(/Usage:/).to_stdout
      end

      it 'returns exit code 0' do
        cli = described_class.new(['help'])
        expect(cli.run).to eq(0)
      end
    end

    context 'with lint command' do
      let(:tmpdir) { Dir.mktmpdir }

      after { FileUtils.remove_entry(tmpdir) }

      it 'lints files and returns 0 for no problems' do
        file = File.join(tmpdir, 'test.yaml')
        File.write(file, "key: value\n")

        cli = described_class.new(['lint', file])
        expect(cli.run).to eq(0)
      end

      it 'returns 1 when problems found' do
        file = File.join(tmpdir, 'test.yaml')
        File.write(file, "key: value   \n")

        cli = described_class.new(['lint', file])
        expect(cli.run).to eq(1)
      end
    end

    context 'with format command' do
      let(:tmpdir) { Dir.mktmpdir }

      after { FileUtils.remove_entry(tmpdir) }

      it 'formats files and returns 0' do
        file = File.join(tmpdir, 'test.yaml')
        File.write(file, "key: value   \n")

        cli = described_class.new(['format', file])
        aggregate_failures do
          expect(cli.run).to eq(0)
          expect(File.read(file)).to eq("key: value\n")
        end
      end
    end

    context 'with file path as first argument' do
      let(:tmpdir) { Dir.mktmpdir }

      after { FileUtils.remove_entry(tmpdir) }

      it 'treats as lint command' do
        file = File.join(tmpdir, 'test.yaml')
        File.write(file, "key: value\n")

        cli = described_class.new([file])
        expect(cli.run).to eq(0)
      end
    end

    context 'with config option' do
      let(:tmpdir) { Dir.mktmpdir }

      after { FileUtils.remove_entry(tmpdir) }

      it 'loads specified config file' do
        config_file = File.join(tmpdir, '.yamllint')
        File.write(config_file, "extends: relaxed\n")

        yaml_file = File.join(tmpdir, 'test.yaml')
        File.write(yaml_file, "key: value   \n")

        cli = described_class.new(['-c', config_file, yaml_file])
        expect(cli.run).to eq(0)
      end
    end
  end
end
