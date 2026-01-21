# frozen_string_literal: true

module Yamlint
  module Rules
    class NewLines < Base
      rule_id 'new-lines'
      desc 'Use consistent line endings throughout the file.'
      defaults({ type: 'unix' })

      def check(context)
        return [] if context.empty?

        expected_type = @config[:type]
        problems = []

        context.lines.each_with_index do |line, index|
          line_number = index + 1
          problem = check_line_ending(line, line_number, expected_type)
          problems << problem if problem
        end

        problems
      end

      def fixable?
        true
      end

      private

      def check_line_ending(line, line_number, expected_type)
        case expected_type
        when 'unix'
          if line.end_with?("\r\n")
            problem(
              line: line_number,
              column: line.length - 1,
              message: 'wrong new line character: expected unix',
              fixable: true
            )
          end
        when 'dos'
          if line.end_with?("\n") && !line.end_with?("\r\n")
            problem(
              line: line_number,
              column: line.length,
              message: 'wrong new line character: expected dos',
              fixable: true
            )
          end
        when 'platform'
          nil
        end
      end
    end

    Registry.register(NewLines)
  end
end
