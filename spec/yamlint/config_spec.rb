# frozen_string_literal: true

RSpec.describe Yamlint::Config do
  describe '.new_with_preset' do
    it 'loads default preset' do
      config = described_class.new_with_preset('default')
      expect(config.rules).to include('trailing-spaces')
    end

    it 'loads relaxed preset' do
      config = described_class.new_with_preset('relaxed')
      expect(config.rules['trailing-spaces']).to eq('disable')
    end

    it 'raises error for unknown preset' do
      expect do
        described_class.new_with_preset('unknown')
      end.to raise_error(ArgumentError, /Unknown preset/)
    end
  end

  describe '#rule_enabled?' do
    let(:config) { described_class.new_with_preset('default') }

    it 'returns true for enabled rules' do
      expect(config.rule_enabled?('trailing-spaces')).to be(true)
    end

    it 'returns false for disabled rules' do
      relaxed = described_class.new_with_preset('relaxed')
      expect(relaxed.rule_enabled?('trailing-spaces')).to be(false)
    end
  end

  describe '#rule_config' do
    let(:config) { described_class.new_with_preset('default') }

    it 'returns config hash for configured rules' do
      result = config.rule_config('line-length')
      expect(result).to include('max' => 80)
    end

    it 'returns empty hash for unconfigured rules' do
      result = config.rule_config('nonexistent')
      expect(result).to eq({})
    end
  end

  describe '#yaml_files' do
    it 'returns default patterns' do
      config = described_class.new({})
      expect(config.yaml_files).to eq(%w[*.yaml *.yml])
    end

    it 'allows custom patterns' do
      config = described_class.new({ 'yaml-files' => ['*.yaml'] })
      expect(config.yaml_files).to eq(['*.yaml'])
    end
  end

  describe '.load_from_file' do
    let(:tmpdir) { Dir.mktmpdir }

    after { FileUtils.remove_entry(tmpdir) }

    it 'loads config from YAML file' do
      config_file = File.join(tmpdir, '.yamllint')
      File.write(config_file, <<~YAML)
        extends: default
        rules:
          line-length:
            max: 100
      YAML

      config = described_class.load_from_file(config_file)
      expect(config.rule_config('line-length')[:max]).to eq(100)
    end
  end

  describe '.build_from_hash' do
    it 'merges with extends preset' do
      data = {
        'extends' => 'default',
        'rules' => {
          'line-length' => { 'max' => 120 }
        }
      }

      config = described_class.build_from_hash(data)
      aggregate_failures do
        expect(config.rule_config('line-length')[:max]).to eq(120)
        expect(config.rule_enabled?('trailing-spaces')).to be(true)
      end
    end
  end
end
