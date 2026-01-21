# frozen_string_literal: true

RSpec.describe Yamlint::Parser do
  describe Yamlint::Parser::CommentExtractor do
    describe '#extract' do
      it 'extracts standalone comments' do
        content = "# This is a comment\nkey: value\n"
        extractor = described_class.new(content)
        comments = extractor.extract

        aggregate_failures do
          expect(comments.length).to eq(1)
          expect(comments.first.text).to eq('This is a comment')
          expect(comments.first.line_number).to eq(1)
          expect(comments.first.inline?).to be(false)
        end
      end

      it 'extracts inline comments' do
        content = "key: value  # inline comment\n"
        extractor = described_class.new(content)
        comments = extractor.extract

        aggregate_failures do
          expect(comments.length).to eq(1)
          expect(comments.first.text).to eq('inline comment')
          expect(comments.first.inline?).to be(true)
        end
      end

      it 'extracts multiple comments' do
        content = "# comment 1\nkey: value  # comment 2\n# comment 3\n"
        extractor = described_class.new(content)
        comments = extractor.extract

        expect(comments.length).to eq(3)
      end

      it 'returns empty array for content without comments' do
        content = "key: value\nother: data\n"
        extractor = described_class.new(content)
        comments = extractor.extract

        expect(comments).to eq([])
      end

      it 'captures column position' do
        content = "    # indented comment\n"
        extractor = described_class.new(content)
        comments = extractor.extract

        expect(comments.first.column).to eq(5)
      end
    end
  end

  describe Yamlint::Parser::Comment do
    describe '#disable_directive?' do
      it 'returns true for disable directive' do
        comment = described_class.new(line_number: 1, column: 1, text: 'yamllint disable')
        expect(comment.disable_directive?).to be(true)
      end

      it 'returns true for disable-line directive' do
        comment = described_class.new(line_number: 1, column: 1, text: 'yamllint disable-line')
        expect(comment.disable_directive?).to be(true)
      end

      it 'returns false for non-disable comments' do
        comment = described_class.new(line_number: 1, column: 1, text: 'regular comment')
        expect(comment.disable_directive?).to be(false)
      end
    end

    describe '#enable_directive?' do
      it 'returns true for enable directive' do
        comment = described_class.new(line_number: 1, column: 1, text: 'yamllint enable')
        expect(comment.enable_directive?).to be(true)
      end

      it 'returns false for non-enable comments' do
        comment = described_class.new(line_number: 1, column: 1, text: 'regular comment')
        expect(comment.enable_directive?).to be(false)
      end
    end

    describe '#disabled_rules' do
      it 'returns empty array for general disable' do
        comment = described_class.new(line_number: 1, column: 1, text: 'yamllint disable')
        expect(comment.disabled_rules).to eq([])
      end

      it 'returns specific rules when specified' do
        comment = described_class.new(line_number: 1, column: 1, text: 'yamllint disable rule1 rule2')
        expect(comment.disabled_rules).to eq(%w[rule1 rule2])
      end

      it 'handles comma-separated rules' do
        comment = described_class.new(line_number: 1, column: 1, text: 'yamllint disable-line rule1, rule2')
        expect(comment.disabled_rules).to eq(%w[rule1 rule2])
      end
    end

    describe '#inline?' do
      it 'returns true for inline comments' do
        comment = described_class.new(line_number: 1, column: 10, text: 'test', inline: true)
        expect(comment.inline?).to be(true)
      end

      it 'returns false for standalone comments' do
        comment = described_class.new(line_number: 1, column: 1, text: 'test', inline: false)
        expect(comment.inline?).to be(false)
      end
    end
  end
end
