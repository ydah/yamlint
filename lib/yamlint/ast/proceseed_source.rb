# frozen_string_literal: true

module Yamlint
  module AST
    class ProcessedSource
      STRING_SOURCE_NAME = '(string)'

      attr_reader :path, :buffer, :ast, :comments, :raw_source

      def self.from_file(path)
        file = File.read(path, mode: 'rb')
        new(file, path)
      end

      def initialize(source, path = nil)
        source.force_encoding(Encoding::UTF_8) unless source.encoding == Encoding::UTF_8

        @raw_source = source
        @path = path

        parse(source)
      end

      private

      def parse(source)
        buffer_name = @path || STRING_SOURCE_NAME
        Yamlint::Parser.run(buffer_name, source)
      end
    end
  end
end
