# frozen_string_literal: true

require 'English'
module Yamlint
  module Rules
    class Commas < LineRule
      rule_id 'commas'
      desc 'Check spaces before and after commas.'
      defaults({
                 'max-spaces-before': 0,
                 'min-spaces-after': 1,
                 'max-spaces-after': 1
               })

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.strip.start_with?('#')

        problems = []
        problems.concat(check_spaces_before_comma(line, line_number))
        problems.concat(check_spaces_after_comma(line, line_number))
        problems
      end

      def fixable?
        true
      end

      private

      def check_spaces_before_comma(line, line_number)
        problems = []
        max_before = @config[:'max-spaces-before']

        line.scan(/(\s+),/) do |match|
          spaces = match[0]
          next unless spaces.length > max_before

          pos = $LAST_MATCH_INFO.begin(0)
          problems << problem(
            line: line_number,
            column: pos + 1,
            message: "too many spaces before comma (#{spaces.length} > #{max_before})",
            fixable: true
          )
        end

        problems
      end

      def check_spaces_after_comma(line, line_number)
        problems = []
        min_after = @config[:'min-spaces-after']
        max_after = @config[:'max-spaces-after']

        line.scan(/,(\s*)/) do |match|
          spaces = match[0]
          next if spaces.include?("\n")

          pos = $LAST_MATCH_INFO.begin(0)

          if spaces.length < min_after
            problems << problem(
              line: line_number,
              column: pos + 2,
              message: "too few spaces after comma (#{spaces.length} < #{min_after})",
              fixable: true
            )
          elsif spaces.length > max_after
            problems << problem(
              line: line_number,
              column: pos + 2,
              message: "too many spaces after comma (#{spaces.length} > #{max_after})",
              fixable: true
            )
          end
        end

        problems
      end
    end

    Registry.register(Commas)
  end
end
