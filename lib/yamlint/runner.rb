# frozen_string_literal: true

module Yamlint
  class Runner
    def initialize(paths = nil)
      @paths = paths
    end

    def run
      paths.each do |file|
        File.open(file, 'r') do |fp|
          puts file
          puts fp.read
        end
      end
    end

    private

    def paths
      @paths ||= target_files
    end

    def target_files(root = '.')
      Dir.glob('**/*.yml', File::FNM_DOTMATCH, base: root).map do |f|
        File.expand_path(f)
      end
    end
  end
end
