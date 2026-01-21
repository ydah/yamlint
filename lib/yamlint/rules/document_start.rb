# frozen_string_literal: true

module Yamlint
  module Rules
    class DocumentStart < Base
      rule_id 'document-start'
      desc 'Require or forbid document start marker.'
      defaults({
                 present: true
               })

      def check(context)
        return [] if context.empty?

        has_start = context.lines.any? { |line| line.strip == '---' }
        required = @config[:present]

        if required && !has_start
          [problem(
            line: 1,
            column: 1,
            message: 'missing document start "---"',
            fixable: true
          )]
        elsif !required && has_start
          line_number = context.lines.index { |line| line.strip == '---' } + 1
          [problem(
            line: line_number,
            column: 1,
            message: 'found forbidden document start "---"',
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

    Registry.register(DocumentStart)
  end
end
