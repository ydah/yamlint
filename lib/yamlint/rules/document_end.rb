# frozen_string_literal: true

module Yamlint
  module Rules
    class DocumentEnd < Base
      rule_id 'document-end'
      desc 'Require or forbid document end marker.'
      defaults({
                 present: false
               })

      def check(context)
        return [] if context.empty?

        has_end = context.lines.any? { |line| line.strip == '...' }
        required = @config[:present]

        if required && !has_end
          [problem(
            line: context.line_count,
            column: 1,
            message: 'missing document end "..."',
            fixable: true
          )]
        elsif !required && has_end
          line_number = context.lines.index { |line| line.strip == '...' } + 1
          [problem(
            line: line_number,
            column: 1,
            message: 'found forbidden document end "..."',
            fixable: true
          )]
        else
          []
        end
      end

      def fixable?
        true
      end
    end

    Registry.register(DocumentEnd)
  end
end
