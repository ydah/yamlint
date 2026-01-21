# frozen_string_literal: true

require 'English'
module Yamlint
  module Rules
    class Colons < LineRule
      rule_id 'colons'
      desc 'Check spaces before and after colons.'
      defaults({
                 'max-spaces-before': 0,
                 'max-spaces-after': 1
               })

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.strip.start_with?('#')

        problems = []
        problems.concat(check_spaces_before_colon(line, line_number))
        problems.concat(check_spaces_after_colon(line, line_number))
        problems
      end

      def fixable?
        true
      end

      private

      def check_spaces_before_colon(line, line_number)
        problems = []
        max_before = @config[:'max-spaces-before']

        line.scan(/(\s+):/) do |match|
          spaces = match[0]
          next unless spaces.length > max_before

          pos = $LAST_MATCH_INFO.begin(0)
          problems << problem(
            line: line_number,
            column: pos + 1,
            message: "too many spaces before colon (#{spaces.length} > #{max_before})",
            fixable: true
          )
        end

        problems
      end

      def check_spaces_after_colon(line, line_number)
        problems = []
        max_after = @config[:'max-spaces-after']

        line.scan(/:(\s{2,})/) do |match|
          spaces = match[0]
          next if spaces.include?("\n")

          pos = $LAST_MATCH_INFO.begin(0)
          problems << problem(
            line: line_number,
            column: pos + 2,
            message: "too many spaces after colon (#{spaces.length} > #{max_after})",
            fixable: true
          )
        end

        problems
      end
    end

    Registry.register(Colons)
  end
end
