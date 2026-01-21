# frozen_string_literal: true

module Yamlint
  module Rules
    class LineLength < LineRule
      rule_id 'line-length'
      desc 'Limit the line length.'
      defaults({
                 max: 80,
                 'allow-non-breakable-words': true,
                 'allow-non-breakable-inline-mappings': true
               })

      def check_line(line, line_number, _context)
        max_length = @config[:max]
        actual_length = line.chomp.length

        return if actual_length <= max_length
        return if allow_non_breakable_words? && non_breakable_word?(line)
        return if allow_non_breakable_inline_mappings? && inline_mapping?(line)

        problem(
          line: line_number,
          column: max_length + 1,
          message: "line too long (#{actual_length} > #{max_length} characters)",
          fixable: false
        )
      end

      private

      def allow_non_breakable_words?
        @config[:'allow-non-breakable-words']
      end

      def allow_non_breakable_inline_mappings?
        @config[:'allow-non-breakable-inline-mappings']
      end

      def non_breakable_word?(line)
        stripped = line.strip
        return false if stripped.empty?

        # Check if the line contains a URL or a very long word
        stripped.match?(%r{https?://\S+}) ||
          stripped.split.any? { |word| word.length > @config[:max] }
      end

      def inline_mapping?(line)
        stripped = line.strip
        stripped.match?(/^\{.*\}$/)
      end
    end

    Registry.register(LineLength)
  end
end
