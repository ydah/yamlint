# frozen_string_literal: true

require 'yaml'

module Yamlint
  class Config
    DEFAULT_CONFIG_FILES = %w[
      .yamllint
      .yamllint.yaml
      .yamllint.yml
    ].freeze

    YAML_FILE_PATTERNS = %w[
      *.yaml
      *.yml
    ].freeze

    attr_reader :rules, :yaml_files, :ignore, :extends

    def initialize(options = {})
      @extends = options[:extends]
      @yaml_files = options[:'yaml-files'] || options['yaml-files'] || YAML_FILE_PATTERNS
      @ignore = options[:ignore] || options['ignore'] || []
      @rules = normalize_rules(options[:rules] || options['rules'] || {})
    end

    def self.load(path = nil)
      if path
        load_from_file(path)
      else
        load_default
      end
    end

    def self.load_from_file(path)
      content = File.read(path)
      data = YAML.safe_load(content, permitted_classes: [Symbol]) || {}
      build_from_hash(data)
    end

    def self.load_default
      config_file = find_config_file
      if config_file
        load_from_file(config_file)
      else
        new_with_preset('default')
      end
    end

    def self.find_config_file
      DEFAULT_CONFIG_FILES.find { |f| File.exist?(f) }
    end

    def self.new_with_preset(preset_name)
      preset = Presets.get(preset_name)
      new(preset)
    end

    def self.build_from_hash(data)
      base_config = if data['extends']
                      Presets.get(data['extends'])
                    else
                      {}
                    end

      merged = deep_merge(base_config, symbolize_keys(data))
      new(merged)
    end

    def rule_config(rule_id)
      @rules[rule_id.to_s] || @rules[rule_id.to_sym] || {}
    end

    def rule_enabled?(rule_id)
      config = rule_config(rule_id)
      config != 'disable' && config != false
    end

    private

    def normalize_rules(rules)
      normalized = {}
      rules.each do |key, value|
        normalized[key.to_s] = value
      end
      normalized
    end

    class << self
      private

      def deep_merge(base, override)
        result = base.dup
        override.each do |key, value|
          result[key] = if value.is_a?(Hash) && result[key].is_a?(Hash)
                          deep_merge(result[key], value)
                        else
                          value
                        end
        end
        result
      end

      def symbolize_keys(hash)
        return hash unless hash.is_a?(Hash)

        hash.transform_keys(&:to_sym).transform_values do |v|
          v.is_a?(Hash) ? symbolize_keys(v) : v
        end
      end
    end
  end
end
