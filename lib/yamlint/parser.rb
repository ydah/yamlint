# frozen_string_literal: true

module Yamlint
  module Parser
    module_function

    def run(name, source)
      puts name
      source.each_line do |line|
        puts line
        AST::Node.new('Comment').inspect if line.start_with?('#')
      end
    end
  end
end
