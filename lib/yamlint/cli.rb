# frozen_string_literal: true

require 'optparse'

module Yamlint
  class Cli
    attr_reader :options

    def initialize(argv = ARGV)
      @argv = argv
      @options = {
        config: nil,
        format: 'colored',
        fix: false,
        dry_run: false,
        strict: false
      }
    end

    def run
      parse_options
      command = @argv.shift || 'lint'

      case command
      when 'lint', 'l'
        run_lint
      when 'format', 'fmt', 'fix'
        run_format
      when 'version', '-v', '--version'
        puts "yamlint #{VERSION}"
        0
      when 'help', '-h', '--help'
        puts help_text
        0
      else
        if File.exist?(command) || File.directory?(command)
          @argv.unshift(command)
          run_lint
        else
          warn "Unknown command: #{command}"
          warn help_text
          1
        end
      end
    end

    private

    def parse_options
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: yamlint [command] [options] [files...]'

        opts.on('-c', '--config FILE', 'Configuration file') do |file|
          @options[:config] = file
        end

        opts.on('-f', '--format FORMAT', 'Output format (standard, parsable, colored, github)') do |format|
          @options[:format] = format
        end

        opts.on('--fix', 'Auto-fix problems') do
          @options[:fix] = true
        end

        opts.on('--dry-run', 'Show what would be fixed without making changes') do
          @options[:dry_run] = true
        end

        opts.on('-s', '--strict', 'Treat warnings as errors') do
          @options[:strict] = true
        end

        opts.on('-v', '--version', 'Show version') do
          puts "yamlint #{VERSION}"
          exit 0
        end

        opts.on('-h', '--help', 'Show help') do
          puts opts
          exit 0
        end
      end

      parser.order!(@argv)
    end

    def run_lint
      paths = @argv.empty? ? ['.'] : @argv
      config = load_config
      runner = Runner.new(config:, output_format: @options[:format])

      result = runner.lint(paths)

      puts result[:output] unless result[:output].empty?
      puts result[:summary] unless result[:summary].empty?

      result[:exit_code]
    end

    def run_format
      paths = @argv.empty? ? ['.'] : @argv
      config = load_config
      runner = Runner.new(config:, output_format: @options[:format])

      result = runner.format(paths, dry_run: @options[:dry_run])

      if @options[:dry_run]
        if result[:changed].positive?
          puts "Would fix #{result[:changed]} file(s):"
          result[:changed_files].each { |f| puts "  #{f}" }
        else
          puts 'No files would be changed'
        end
      elsif result[:changed].positive?
        puts "Fixed #{result[:changed]} file(s)"
      else
        puts 'No files changed'
      end

      result[:exit_code]
    end

    def load_config
      if @options[:config]
        Config.load(@options[:config])
      else
        Config.load_default
      end
    end

    def help_text
      <<~HELP
        yamlint - A YAML file linter and formatter

        Usage:
          yamlint [command] [options] [files...]

        Commands:
          lint, l       Lint YAML files (default)
          format, fmt   Format YAML files
          version       Show version
          help          Show help

        Options:
          -c, --config FILE     Configuration file
          -f, --format FORMAT   Output format (standard, parsable, colored, github)
          --fix                 Auto-fix problems
          --dry-run             Show what would be fixed without making changes
          -s, --strict          Treat warnings as errors
          -v, --version         Show version
          -h, --help            Show help

        Examples:
          yamlint .
          yamlint file.yaml
          yamlint -c .yamllint.yml .
          yamlint format --dry-run .
          yamlint -f github .
      HELP
    end
  end
end
