# frozen_string_literal: true

module Yamlint
  module AST
    class Node
      attr_reader :type

      def initialize(type)
        @type = type
      end

      def inspect
        puts @type
      end
    end
  end
end
