# frozen_string_literal: true

require 'English'
module Yamlint
  module Rules
    class Brackets < LineRule
      rule_id 'brackets'
      desc 'Check spaces inside brackets.'
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

        if @config[:forbid] && line.include?('[')
          problems << problem(
            line: line_number,
            column: line.index('[') + 1,
            message: 'flow sequence (brackets) forbidden',
            fixable: false
          )
          return problems
        end

        problems.concat(check_opening_bracket(line, line_number))
        problems.concat(check_closing_bracket(line, line_number))
        problems
      end

      def fixable?
        true
      end

      private

      def check_opening_bracket(line, line_number)
        problems = []
        min_spaces = @config[:'min-spaces-inside']
        max_spaces = @config[:'max-spaces-inside']

        line.scan(/\[(\s*)(?!\])/) do |match|
          spaces = match[0]
          pos = $LAST_MATCH_INFO.begin(0)

          if spaces.length < min_spaces
            problems << problem(
              line: line_number,
              column: pos + 2,
              message: "too few spaces inside brackets (#{spaces.length} < #{min_spaces})",
              fixable: true
            )
          elsif spaces.length > max_spaces
            problems << problem(
              line: line_number,
              column: pos + 2,
              message: "too many spaces inside brackets (#{spaces.length} > #{max_spaces})",
              fixable: true
            )
          end
        end

        problems
      end

      def check_closing_bracket(line, line_number)
        problems = []
        min_spaces = @config[:'min-spaces-inside']
        max_spaces = @config[:'max-spaces-inside']

        line.scan(/(?<!\[)(\s*)\]/) do |match|
          spaces = match[0]
          pos = $LAST_MATCH_INFO.begin(0)

          if spaces.length < min_spaces
            problems << problem(
              line: line_number,
              column: pos + 1,
              message: "too few spaces inside brackets (#{spaces.length} < #{min_spaces})",
              fixable: true
            )
          elsif spaces.length > max_spaces
            problems << problem(
              line: line_number,
              column: pos + 1,
              message: "too many spaces inside brackets (#{spaces.length} > #{max_spaces})",
              fixable: true
            )
          end
        end

        problems
      end
    end

    Registry.register(Brackets)
  end
end
