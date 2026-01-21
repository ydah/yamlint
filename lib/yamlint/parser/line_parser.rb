# frozen_string_literal: true

module Yamlint
  module Parser
    class LineParser
      def initialize(content)
        @content = content
      end

      def parse
        @content.lines
      end

      def line_at(line_number)
        lines = parse
        lines[line_number - 1]
      end

      def line_count
        parse.length
      end

      def each_line_with_number(&)
        parse.each_with_index do |line, index|
          yield(line, index + 1)
        end
      end
    end
  end
end
