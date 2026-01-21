# frozen_string_literal: true

module Yamlint
  module Rules
    class FloatValues < LineRule
      rule_id 'float-values'
      desc 'Check float value formatting.'
      defaults({
                 'forbid-scientific-notation': false,
                 'forbid-nan': false,
                 'forbid-inf': false,
                 'require-numeral-before-decimal': false
               })

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.strip.start_with?('#')

        problems = []

        if @config[:'forbid-scientific-notation'] && line.match?(/:\s*[\d.]+[eE][+-]?\d+/)
          problems << problem(
            line: line_number,
            column: line.index(':') + 1,
            message: 'scientific notation forbidden',
            fixable: false
          )
        end

        if @config[:'forbid-nan'] && line.match?(/:\s*\.nan\s*(?:#.*)?$/i)
          problems << problem(
            line: line_number,
            column: line.index(':') + 1,
            message: '.nan value forbidden',
            fixable: false
          )
        end

        if @config[:'forbid-inf'] && line.match?(/:\s*[+-]?\.inf\s*(?:#.*)?$/i)
          problems << problem(
            line: line_number,
            column: line.index(':') + 1,
            message: '.inf value forbidden',
            fixable: false
          )
        end

        if @config[:'require-numeral-before-decimal'] && line.match?(/:\s*\.\d+/)
          problems << problem(
            line: line_number,
            column: line.index(':') + 1,
            message: 'numeral required before decimal point',
            fixable: true
          )
        end

        problems
      end

      def fixable?
        @config[:'require-numeral-before-decimal']
      end
    end

    Registry.register(FloatValues)
  end
end
