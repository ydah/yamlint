# frozen_string_literal: true

RSpec.describe Yamlint::Presets do
  describe '.get' do
    it 'returns default preset' do
      preset = described_class.get('default')
      expect(preset[:rules]).to include('trailing-spaces')
    end

    it 'returns relaxed preset' do
      preset = described_class.get('relaxed')
      expect(preset[:rules]['trailing-spaces']).to eq('disable')
    end

    it 'raises error for unknown preset' do
      expect do
        described_class.get('unknown')
      end.to raise_error(ArgumentError, /Unknown preset/)
    end

    it 'accepts symbols' do
      preset = described_class.get(:default)
      expect(preset).to be_a(Hash)
    end
  end

  describe 'DEFAULT preset' do
    let(:preset) { described_class::DEFAULT }

    it 'enables trailing-spaces' do
      expect(preset[:rules]['trailing-spaces']).to eq({})
    end

    it 'disables document-start by default' do
      expect(preset[:rules]['document-start']).to eq('disable')
    end

    it 'configures line-length to 80' do
      expect(preset[:rules]['line-length']['max']).to eq(80)
    end

    it 'configures indentation to 2 spaces' do
      expect(preset[:rules]['indentation']['spaces']).to eq(2)
    end
  end

  describe 'RELAXED preset' do
    let(:preset) { described_class::RELAXED }

    it 'disables trailing-spaces' do
      expect(preset[:rules]['trailing-spaces']).to eq('disable')
    end

    it 'disables indentation' do
      expect(preset[:rules]['indentation']).to eq('disable')
    end

    it 'configures line-length to 120' do
      expect(preset[:rules]['line-length']['max']).to eq(120)
    end
  end
end
