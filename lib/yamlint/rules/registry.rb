# frozen_string_literal: true

module Yamlint
  module Rules
    class Registry
      DISABLED_VALUES = ['disable', false].freeze

      class << self
        def rules
          @rules ||= {}
        end

        def register(rule_class)
          rules[rule_class.id] = rule_class
        end

        def get(rule_id)
          rules[rule_id]
        end

        def all
          rules.values
        end

        def ids
          rules.keys
        end

        def build(config)
          rules_config = config[:rules] || {}
          enabled_rules = []

          rules.each do |rule_id, rule_class|
            rule_config = rules_config[rule_id] || rules_config[rule_id.to_sym] || {}

            next if DISABLED_VALUES.include?(rule_config)
            next if rule_config.is_a?(Hash) && rule_config[:enable] == false

            rule_options = rule_config.is_a?(Hash) ? rule_config : {}
            enabled_rules << rule_class.new(rule_options)
          end

          enabled_rules
        end
      end
    end
  end
end
