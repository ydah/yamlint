# frozen_string_literal: true

module Yamlint
  module Rules
    class OctalValues < LineRule
      rule_id 'octal-values'
      desc 'Forbid implicit or explicit octal values.'
      defaults({
                 'forbid-implicit-octal': true,
                 'forbid-explicit-octal': false
               })

      IMPLICIT_OCTAL_PATTERN = /:\s*0[0-7]+\s*(?:#.*)?$/
      EXPLICIT_OCTAL_PATTERN = /:\s*0o[0-7]+\s*(?:#.*)?$/i

      IMPLICIT_VALUE_PATTERN = /:\s*(0[0-7]+)/
      EXPLICIT_VALUE_PATTERN = /:\s*(0o[0-7]+)/i

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.strip.start_with?('#')

        problems = []
        check_implicit_octal(line, line_number, problems)
        check_explicit_octal(line, line_number, problems)
        problems
      end

      private

      def check_implicit_octal(line, line_number, problems)
        return unless @config[:'forbid-implicit-octal'] && line.match?(IMPLICIT_OCTAL_PATTERN)

        match = line.match(IMPLICIT_VALUE_PATTERN)
        return unless match

        problems << problem(
          line: line_number,
          column: match.begin(1) + 1,
          message: "forbidden implicit octal value \"#{match[1]}\"",
          fixable: false
        )
      end

      def check_explicit_octal(line, line_number, problems)
        return unless @config[:'forbid-explicit-octal'] && line.match?(EXPLICIT_OCTAL_PATTERN)

        match = line.match(EXPLICIT_VALUE_PATTERN)
        return unless match

        problems << problem(
          line: line_number,
          column: match.begin(1) + 1,
          message: "forbidden explicit octal value \"#{match[1]}\"",
          fixable: false
        )
      end
    end

    Registry.register(OctalValues)
  end
end
