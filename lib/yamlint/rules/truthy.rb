# frozen_string_literal: true

module Yamlint
  module Rules
    class Truthy < LineRule
      rule_id 'truthy'
      desc 'Forbid truthy values that are not true/false.'
      defaults({
                 'allowed-values': %w[true false],
                 'check-keys': true
               })

      TRUTHY_VALUES = %w[
        YES Yes yes
        NO No no
        TRUE True
        FALSE False
        ON On on
        OFF Off off
      ].freeze

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.strip.start_with?('#')

        problems = []
        allowed = @config[:'allowed-values']

        TRUTHY_VALUES.each do |truthy|
          next if allowed.include?(truthy)

          next unless line.match?(/:\s*#{Regexp.escape(truthy)}\s*(?:#.*)?$/)

          problems << problem(
            line: line_number,
            column: line.index(truthy) + 1,
            message: "truthy value should be one of [#{allowed.join(', ')}]",
            fixable: false
          )
        end

        problems
      end
    end

    Registry.register(Truthy)
  end
end
