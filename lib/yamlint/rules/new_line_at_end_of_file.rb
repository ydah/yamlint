# frozen_string_literal: true

module Yamlint
  module Rules
    class NewLineAtEndOfFile < Base
      rule_id 'new-line-at-end-of-file'
      desc 'Require a new line character at the end of files.'
      defaults({})

      def check(context)
        return [] if context.empty?

        last_char = context.content[-1]
        return [] if last_char == "\n"

        [problem(
          line: context.line_count,
          column: (context.lines.last&.length || 0) + 1,
          message: 'no new line character at the end of file',
          fixable: true
        )]
      end

      def fixable?
        true
      end
    end

    Registry.register(NewLineAtEndOfFile)
  end
end
