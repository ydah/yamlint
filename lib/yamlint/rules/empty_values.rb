# frozen_string_literal: true

module Yamlint
  module Rules
    class EmptyValues < LineRule
      rule_id 'empty-values'
      desc 'Forbid empty values in mappings.'
      defaults({
                 'forbid-in-block-mappings': true,
                 'forbid-in-flow-mappings': true
               })

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.strip.start_with?('#')

        problems = []

        if @config[:'forbid-in-block-mappings'] && line.match?(/:\s*$/) && !line.match?(/[|>]/)
          problems << problem(
            line: line_number,
            column: line.index(':') + 1,
            message: 'empty value in block mapping',
            fixable: false
          )
        end

        if @config[:'forbid-in-flow-mappings'] && line.match?(/:\s*[,}]/)
          problems << problem(
            line: line_number,
            column: line.index(':') + 1,
            message: 'empty value in flow mapping',
            fixable: false
          )
        end

        problems
      end
    end

    Registry.register(EmptyValues)
  end
end
