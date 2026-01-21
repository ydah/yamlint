# frozen_string_literal: true

RSpec.describe Yamlint::Rules::Registry do
  describe '.register' do
    it 'registers a rule class' do
      Yamlint::Rules.load_all
      expect(described_class.get('trailing-spaces')).to eq(Yamlint::Rules::TrailingSpaces)
    end
  end

  describe '.all' do
    it 'returns all registered rule classes' do
      Yamlint::Rules.load_all
      all_rules = described_class.all

      expect(all_rules).to include(Yamlint::Rules::TrailingSpaces)
    end
  end

  describe '.ids' do
    it 'returns all registered rule IDs' do
      Yamlint::Rules.load_all
      ids = described_class.ids

      expect(ids).to include('trailing-spaces', 'line-length', 'indentation')
    end
  end

  describe '.build' do
    before { Yamlint::Rules.load_all }

    it 'builds enabled rules from config' do
      config = {
        rules: {
          'trailing-spaces' => {},
          'line-length' => { max: 100 }
        }
      }

      rules = described_class.build(config)

      expect(rules).to all(be_a(Yamlint::Rules::Base))
    end

    it 'returns no disabled rules in build results' do
      config = {
        rules: {
          'trailing-spaces' => 'disable'
        }
      }

      rules = described_class.build(config)
      rule_ids = rules.map { |r| r.class.id }

      expect(rule_ids).not_to include('trailing-spaces')
    end

    it 'returns nil when finding a disabled rule' do
      config = {
        rules: {
          'trailing-spaces' => 'disable'
        }
      }

      rules = described_class.build(config)
      trailing_rule = rules.find { |r| r.class.id == 'trailing-spaces' }

      expect(trailing_rule).to be_nil
    end

    it 'passes options to rules' do
      config = {
        rules: {
          'line-length' => { max: 120 }
        }
      }

      rules = described_class.build(config)
      line_length_rule = rules.find { |r| r.class.id == 'line-length' }

      expect(line_length_rule.config[:max]).to eq(120)
    end
  end
end
