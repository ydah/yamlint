# frozen_string_literal: true

module Yamlint
  module Rules
    class Indentation < LineRule
      rule_id 'indentation'
      desc 'Enforce consistent indentation.'
      defaults({
                 spaces: 2,
                 'indent-sequences': true,
                 'check-multi-line-strings': false
               })

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.start_with?('#')

        expected_spaces = @config[:spaces]
        leading_spaces = line[/\A */].length

        return if leading_spaces.zero?
        return if (leading_spaces % expected_spaces).zero?

        problem(
          line: line_number,
          column: 1,
          message: "wrong indentation: expected #{expected_spaces}n spaces",
          fixable: true
        )
      end

      def fixable?
        true
      end
    end

    Registry.register(Indentation)
  end
end
