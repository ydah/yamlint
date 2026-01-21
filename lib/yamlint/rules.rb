# frozen_string_literal: true

module Yamlint
  module Rules
    autoload :Base, 'yamlint/rules/base'
    autoload :LineRule, 'yamlint/rules/base'
    autoload :TokenRule, 'yamlint/rules/base'
    autoload :CommentRule, 'yamlint/rules/base'
    autoload :Registry, 'yamlint/rules/registry'

    autoload :TrailingSpaces, 'yamlint/rules/trailing_spaces'
    autoload :NewLineAtEndOfFile, 'yamlint/rules/new_line_at_end_of_file'
    autoload :NewLines, 'yamlint/rules/new_lines'
    autoload :LineLength, 'yamlint/rules/line_length'
    autoload :EmptyLines, 'yamlint/rules/empty_lines'
    autoload :Indentation, 'yamlint/rules/indentation'
    autoload :Colons, 'yamlint/rules/colons'
    autoload :Commas, 'yamlint/rules/commas'
    autoload :Braces, 'yamlint/rules/braces'
    autoload :Brackets, 'yamlint/rules/brackets'
    autoload :Hyphens, 'yamlint/rules/hyphens'
    autoload :Comments, 'yamlint/rules/comments'
    autoload :CommentsIndentation, 'yamlint/rules/comments_indentation'
    autoload :DocumentStart, 'yamlint/rules/document_start'
    autoload :DocumentEnd, 'yamlint/rules/document_end'
    autoload :EmptyValues, 'yamlint/rules/empty_values'
    autoload :KeyDuplicates, 'yamlint/rules/key_duplicates'
    autoload :KeyOrdering, 'yamlint/rules/key_ordering'
    autoload :Truthy, 'yamlint/rules/truthy'
    autoload :QuotedStrings, 'yamlint/rules/quoted_strings'
    autoload :OctalValues, 'yamlint/rules/octal_values'
    autoload :FloatValues, 'yamlint/rules/float_values'
    autoload :Anchors, 'yamlint/rules/anchors'

    def self.load_all
      constants(false).each do |const_name|
        const_get(const_name)
      end
    end
  end
end
