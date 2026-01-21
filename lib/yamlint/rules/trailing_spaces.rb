# frozen_string_literal: true

module Yamlint
  module Rules
    class TrailingSpaces < LineRule
      rule_id 'trailing-spaces'
      desc 'Forbid trailing spaces at the end of lines.'
      defaults({})

      def check_line(line, line_number, _context)
        return if line.chomp.empty?

        trailing = line[/[ \t]+$/]
        return unless trailing

        problem(
          line: line_number,
          column: line.rstrip.length + 1,
          message: 'trailing spaces',
          fixable: true
        )
      end

      def fixable?
        true
      end
    end

    Registry.register(TrailingSpaces)
  end
end
