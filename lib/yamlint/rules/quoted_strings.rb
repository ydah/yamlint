# frozen_string_literal: true

module Yamlint
  module Rules
    class QuotedStrings < LineRule
      rule_id 'quoted-strings'
      desc 'Check quoting style of strings.'
      defaults({
                 'quote-type': 'any',
                 required: false,
                 'extra-required': [],
                 'extra-allowed': [],
                 'allow-quoted-quotes': false
               })

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.strip.start_with?('#')
        return unless @config[:required]

        problems = []
        quote_type = @config[:'quote-type']

        if line.match?(/:.*[^"']\s*$/) && !multiline_indicator?(line)
          if @config[:required] == 'only-when-needed'
            # Check if quoting is needed
          else
            problems << problem(
              line: line_number,
              column: line.index(':') + 1,
              message: 'string value is not quoted',
              fixable: false
            )
          end
        end

        if quote_type == 'single' && line.include?('"')
          if (match = line.match(/:\s*"[^"]*"/))
            problems << problem(
              line: line_number,
              column: match.begin(0) + 1,
              message: 'wrong quote type (expected single)',
              fixable: true
            )
          end
        elsif quote_type == 'double' && line.include?("'")
          if (match = line.match(/:\s*'[^']*'/))
            problems << problem(
              line: line_number,
              column: match.begin(0) + 1,
              message: 'wrong quote type (expected double)',
              fixable: true
            )
          end
        end

        problems
      end

      def fixable?
        true
      end

      private

      def multiline_indicator?(line)
        line.match?(/[|>][-+]?\s*$/)
      end
    end

    Registry.register(QuotedStrings)
  end
end
