# frozen_string_literal: true

module Yamlint
  module AST
    class Node
      attr_reader :type

      def initialize(type, line)
        @type = type
        @line = line
        @indentation = indentation
      end

      def inspect
        puts "type: #{@type}"
        puts "indentation: #{@indentation}"
      end

      private

      def indentation
        @line.match(/\A */).to_s.size
      end
    end
  end
end
