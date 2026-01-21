# frozen_string_literal: true

module Yamlint
  class Runner
    attr_reader :config, :output_format

    def initialize(config: nil, output_format: 'colored')
      @config = config || Config.load_default
      @output_format = output_format
      @linter = Linter.new(@config)
      @formatter = Formatter.new(@config)
      @output = Output.get(output_format)
    end

    def lint(paths)
      files = collect_files(paths)
      total_problems = 0
      results = []

      files.each do |filepath|
        problems = @linter.lint_file(filepath)
        total_problems += problems.length

        output = @output.format(filepath, problems)
        results << output unless output.empty?
      end

      summary = @output.format_summary(files.length, total_problems)

      {
        files: files.length,
        problems: total_problems,
        output: results.join("\n\n"),
        summary:,
        exit_code: total_problems.positive? ? 1 : 0
      }
    end

    def format(paths, dry_run: false)
      files = collect_files(paths)
      changed_files = []

      files.each do |filepath|
        original = File.read(filepath)
        formatted = @formatter.format(original, dry_run:)

        if original != formatted
          changed_files << filepath
          File.write(filepath, formatted) unless dry_run
        end
      end

      {
        files: files.length,
        changed: changed_files.length,
        changed_files:,
        exit_code: 0
      }
    end

    private

    def collect_files(paths)
      files = []
      yaml_patterns = @config.yaml_files

      paths.each do |path|
        if File.directory?(path)
          yaml_patterns.each do |pattern|
            files.concat(Dir.glob(File.join(path, '**', pattern)))
          end
        elsif File.file?(path)
          files << path
        end
      end

      files.uniq.sort
    end
  end
end
