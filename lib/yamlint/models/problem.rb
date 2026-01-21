# frozen_string_literal: true

module Yamlint
  module Models
    class Problem
      attr_reader :line, :column, :rule, :level, :message, :fixable

      LEVELS = %i[error warning info].freeze

      def initialize(line:, column:, rule:, level:, message:, fixable: false)
        @line = line
        @column = column
        @rule = rule
        @level = validate_level(level)
        @message = message
        @fixable = fixable
      end

      def error?
        @level == :error
      end

      def warning?
        @level == :warning
      end

      def fixable?
        @fixable
      end

      def to_s
        "#{line}:#{column} [#{level}] #{message} (#{rule})"
      end

      private

      def validate_level(level)
        return level if LEVELS.include?(level)

        raise ArgumentError, "Invalid level: #{level}. Must be one of #{LEVELS.join(', ')}"
      end
    end
  end
end
