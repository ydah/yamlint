# frozen_string_literal: true

module Yamlint
  module Commands
    class Lint
      class << self
        def call
          new.call
        end
      end

      def call
        files.each do |file|
          File.open(file, "r") do |fp|
            puts file
            puts fp.read
          end
        end
      end

      private

      def files(root = '.')
        Dir.glob('**/*.yml', File::FNM_DOTMATCH, base: root).map do |f|
          File.join(root, f)
        end
      end
    end
  end
end
