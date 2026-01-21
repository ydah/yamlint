# frozen_string_literal: true

module Yamlint
  module Rules
    class CommentsIndentation < Base
      rule_id 'comments-indentation'
      desc 'Check comments indentation.'
      defaults({})

      def check(context)
        problems = []

        context.lines.each_with_index do |line, index|
          line_number = index + 1

          next unless line.strip.start_with?('#')

          current_indent = line[/\A */].length
          expected_indent = expected_indent_for_comment(context.lines, index)

          next unless expected_indent && current_indent != expected_indent

          problems << problem(
            line: line_number,
            column: 1,
            message: "comment not indented correctly (expected #{expected_indent}, found #{current_indent})",
            fixable: true
          )
        end

        problems
      end

      def fixable?
        true
      end

      private

      def expected_indent_for_comment(lines, index)
        next_indent = find_indent(lines, (index + 1)...lines.length)
        return next_indent unless next_indent.nil?

        previous_indent = find_indent(lines, (index - 1).downto(0))
        return previous_indent unless previous_indent.nil?

        0
      end

      def find_indent(lines, range)
        range.each do |i|
          line = lines[i]
          next if line.nil?

          stripped = line.strip
          next if stripped.empty? || stripped.start_with?('#')

          return line[/\A */].length
        end
        nil
      end
    end

    Registry.register(CommentsIndentation)
  end
end
