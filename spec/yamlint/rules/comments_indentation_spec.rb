# frozen_string_literal: true

RSpec.describe Yamlint::Rules::CommentsIndentation do
  let(:rule) { described_class.new }

  describe '#check' do
    it 'detects wrongly indented comment' do
      content = "key: value\n    # wrong indent\nother: data\n"
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).not_to be_empty
    end

    it 'accepts correctly indented comment' do
      content = <<~YAML
        key: value
        # correct indent
        other: data
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_empty
    end

    it 'handles nested structures' do
      content = <<~YAML
        parent:
          # comment at nested level
          child: value
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe '#fixable?' do
    it 'returns true' do
      expect(rule.fixable?).to be(true)
    end
  end
end
