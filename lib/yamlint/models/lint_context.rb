# frozen_string_literal: true

module Yamlint
  module Models
    class LintContext
      attr_reader :filepath, :content, :lines, :tokens, :comments
      attr_accessor :problems

      def initialize(filepath:, content:)
        @filepath = filepath
        @content = content
        @lines = content.lines
        @tokens = []
        @comments = []
        @problems = []
      end

      def add_problem(problem)
        @problems << problem
      end

      def add_token(token)
        @tokens << token
      end

      def add_comment(comment)
        @comments << comment
      end

      def line_count
        @lines.length
      end

      def line_at(line_number)
        @lines[line_number - 1]
      end

      def empty?
        @content.empty?
      end
    end
  end
end
