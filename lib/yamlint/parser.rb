# frozen_string_literal: true

module Yamlint
  module Parser
    module_function

    def run(name, source)
      puts name
      source.each_line do |line|
        node = AST::Node.new('Not impl', line)
        node = AST::Node.new('Comment', line) if line.start_with?('#')

        puts node.inspect
      end
    end
  end
end
