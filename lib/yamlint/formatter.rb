# frozen_string_literal: true

require 'date'
require 'yaml'

module Yamlint
  class Formatter
    attr_reader :config

    def initialize(config = nil)
      @config = config || Config.load_default
    end

    def format(content, dry_run: false)
      original = content.dup
      result = content

      result = fix_trailing_spaces(result)
      result = fix_new_line_at_end(result)
      result = fix_new_lines(result)
      result = fix_empty_lines(result)

      return original if dry_run

      if safe_fix?(original, result)
        result
      else
        original
      end
    end

    def format_file(filepath, dry_run: false)
      content = File.read(filepath)
      formatted = format(content, dry_run:)

      File.write(filepath, formatted) unless dry_run || content == formatted

      formatted
    end

    private

    def fix_trailing_spaces(content)
      content.gsub(/[ \t]+$/, '')
    end

    def fix_new_line_at_end(content)
      return content if content.empty?
      return content if content.end_with?("\n")

      "#{content}\n"
    end

    def fix_new_lines(content)
      new_line_type = @config.rules['new-lines']
      return content unless new_line_type.is_a?(Hash)

      type = new_line_type['type'] || new_line_type[:type] || 'unix'
      case type
      when 'unix'
        content.gsub("\r\n", "\n")
      when 'dos'
        content.gsub(/(?<!\r)\n/, "\r\n")
      else
        content
      end
    end

    def fix_empty_lines(content)
      lines = content.lines
      return content if lines.empty?

      empty_lines_config = @config.rules['empty-lines'] || {}
      return content unless empty_lines_config.is_a?(Hash)

      max_start = empty_lines_config['max-start'] || empty_lines_config[:'max-start'] || 0
      max_end = empty_lines_config['max-end'] || empty_lines_config[:'max-end'] || 0
      max = empty_lines_config['max'] || empty_lines_config[:max] || 2

      lines = remove_start_empty_lines(lines, max_start)
      lines = remove_end_empty_lines(lines, max_end)
      lines = limit_consecutive_empty_lines(lines, max)

      lines.join
    end

    def remove_start_empty_lines(lines, max)
      count = 0
      lines.each do |line|
        break unless line.strip.empty?

        count += 1
      end

      lines.drop([count - max, 0].max)
    end

    def remove_end_empty_lines(lines, max)
      count = 0
      lines.reverse_each do |line|
        break unless line.strip.empty?

        count += 1
      end

      to_remove = [count - max, 0].max
      to_remove.positive? ? lines[0...-to_remove] : lines
    end

    def limit_consecutive_empty_lines(lines, max)
      result = []
      consecutive_empty = 0

      lines.each do |line|
        if line.strip.empty?
          consecutive_empty += 1
          result << line if consecutive_empty <= max
        else
          consecutive_empty = 0
          result << line
        end
      end

      result
    end

    def safe_fix?(original, fixed)
      return true if original == fixed
      return false if original.empty? || fixed.empty?

      begin
        original_data = YAML.safe_load(original, permitted_classes: [Symbol, Date, Time])
        fixed_data = YAML.safe_load(fixed, permitted_classes: [Symbol, Date, Time])
        original_data == fixed_data
      rescue Psych::SyntaxError
        false
      end
    end
  end
end
