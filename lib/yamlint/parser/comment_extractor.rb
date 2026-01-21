# frozen_string_literal: true

module Yamlint
  module Parser
    class Comment
      attr_reader :line_number, :column, :text, :inline

      def initialize(line_number:, column:, text:, inline: false)
        @line_number = line_number
        @column = column
        @text = text
        @inline = inline
      end

      def inline?
        @inline
      end

      def disable_directive?
        @text.match?(/yamllint\s+disable(-line)?/)
      end

      def enable_directive?
        @text.match?(/yamllint\s+enable/)
      end

      def disabled_rules
        if (match = @text.match(/yamllint\s+disable(-line)?\s+(.+)/))
          match[2].split(/[,\s]+/).map(&:strip).reject(&:empty?)
        else
          []
        end
      end
    end

    class CommentExtractor
      COMMENT_PATTERN = /#(.*)$/

      def initialize(content)
        @content = content
      end

      def extract
        comments = []
        @content.lines.each_with_index do |line, index|
          line_number = index + 1
          extract_comments_from_line(line, line_number, comments)
        end
        comments
      end

      private

      def extract_comments_from_line(line, line_number, comments)
        return if in_string?(line)

        if (match = line.match(COMMENT_PATTERN))
          column = match.begin(0) + 1
          text = match[1].strip
          inline = column > 1 && !line[0...(column - 1)].strip.empty?

          comments << Comment.new(
            line_number:,
            column:,
            text:,
            inline:
          )
        end
      end

      def in_string?(_line)
        # Simple heuristic: skip lines that start with quotes
        # A more complete implementation would track string state
        false
      end
    end
  end
end
