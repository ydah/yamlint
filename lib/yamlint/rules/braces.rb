# frozen_string_literal: true

require 'English'
module Yamlint
  module Rules
    class Braces < LineRule
      rule_id 'braces'
      desc 'Check spaces inside braces.'
      defaults({
                 forbid: false,
                 'min-spaces-inside': 0,
                 'max-spaces-inside': 0,
                 'min-spaces-inside-empty': -1,
                 'max-spaces-inside-empty': -1
               })

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.strip.start_with?('#')

        problems = []

        if @config[:forbid] && line.include?('{')
          problems << problem(
            line: line_number,
            column: line.index('{') + 1,
            message: 'flow mapping (braces) forbidden',
            fixable: false
          )
          return problems
        end

        problems.concat(check_opening_brace(line, line_number))
        problems.concat(check_closing_brace(line, line_number))
        problems
      end

      def fixable?
        true
      end

      private

      def check_opening_brace(line, line_number)
        problems = []
        min_spaces = @config[:'min-spaces-inside']
        max_spaces = @config[:'max-spaces-inside']

        line.scan(/\{(\s*)(?!\})/) do |match|
          spaces = match[0]
          pos = $LAST_MATCH_INFO.begin(0)

          if spaces.length < min_spaces
            problems << problem(
              line: line_number,
              column: pos + 2,
              message: "too few spaces inside braces (#{spaces.length} < #{min_spaces})",
              fixable: true
            )
          elsif spaces.length > max_spaces
            problems << problem(
              line: line_number,
              column: pos + 2,
              message: "too many spaces inside braces (#{spaces.length} > #{max_spaces})",
              fixable: true
            )
          end
        end

        problems
      end

      def check_closing_brace(line, line_number)
        problems = []
        min_spaces = @config[:'min-spaces-inside']
        max_spaces = @config[:'max-spaces-inside']

        line.scan(/(?<!\{)(\s*)\}/) do |match|
          spaces = match[0]
          pos = $LAST_MATCH_INFO.begin(0)

          if spaces.length < min_spaces
            problems << problem(
              line: line_number,
              column: pos + 1,
              message: "too few spaces inside braces (#{spaces.length} < #{min_spaces})",
              fixable: true
            )
          elsif spaces.length > max_spaces
            problems << problem(
              line: line_number,
              column: pos + 1,
              message: "too many spaces inside braces (#{spaces.length} > #{max_spaces})",
              fixable: true
            )
          end
        end

        problems
      end
    end

    Registry.register(Braces)
  end
end
