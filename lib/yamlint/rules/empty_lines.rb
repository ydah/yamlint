# frozen_string_literal: true

module Yamlint
  module Rules
    class EmptyLines < Base
      rule_id 'empty-lines'
      desc 'Limit the number of consecutive blank lines.'
      defaults({
                 max: 2,
                 'max-start': 0,
                 'max-end': 0
               })

      def check(context)
        return [] if context.empty?

        problems = []
        problems.concat(check_start_empty_lines(context))
        problems.concat(check_end_empty_lines(context))
        problems.concat(check_consecutive_empty_lines(context))
        problems
      end

      def fixable?
        true
      end

      private

      def check_start_empty_lines(context)
        max_start = @config[:'max-start']
        count = 0

        context.lines.each do |line|
          break unless blank_line?(line)

          count += 1
        end

        return [] if count <= max_start

        [problem(
          line: 1,
          column: 1,
          message: "too many blank lines at the beginning of file (#{count} > #{max_start})",
          fixable: true
        )]
      end

      def check_end_empty_lines(context)
        max_end = @config[:'max-end']
        count = 0
        lines = context.lines

        lines.reverse_each do |line|
          break unless blank_line?(line)

          count += 1
        end

        return [] if count <= max_end

        [problem(
          line: context.line_count - count + 1,
          column: 1,
          message: "too many blank lines at the end of file (#{count} > #{max_end})",
          fixable: true
        )]
      end

      def check_consecutive_empty_lines(context)
        max = @config[:max]
        problems = []
        consecutive_count = 0
        first_blank_line = nil

        context.lines.each_with_index do |line, index|
          line_number = index + 1

          if blank_line?(line)
            first_blank_line ||= line_number
            consecutive_count += 1
          else
            if consecutive_count > max
              problems << problem(
                line: first_blank_line,
                column: 1,
                message: "too many blank lines (#{consecutive_count} > #{max})",
                fixable: true
              )
            end
            consecutive_count = 0
            first_blank_line = nil
          end
        end

        problems
      end

      def blank_line?(line)
        line.strip.empty?
      end
    end

    Registry.register(EmptyLines)
  end
end
