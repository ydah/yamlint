# frozen_string_literal: true

module Yamlint
  module Models
    class Token
      attr_reader :type, :value, :start_line, :start_column, :end_line, :end_column

      def initialize(type:, start_line:, start_column:, value: nil, end_line: nil, end_column: nil)
        @type = type
        @value = value
        @start_line = start_line
        @start_column = start_column
        @end_line = end_line || start_line
        @end_column = end_column || start_column
      end

      def to_s
        "#{type}(#{start_line}:#{start_column})"
      end
    end
  end
end
