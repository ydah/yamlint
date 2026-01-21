# frozen_string_literal: true

RSpec.describe Yamlint::Rules::Anchors do
  describe 'forbid-undeclared-aliases' do
    let(:rule) do
      described_class.new({ 'forbid-undeclared-aliases': true, 'forbid-duplicated-anchors': false,
                            'forbid-unused-anchors': false })
    end

    it 'detects undeclared alias' do
      content = <<~YAML
        key: *undefined
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('undefined alias'))
    end

    it 'accepts declared alias' do
      content = <<~YAML
        anchor: &myanchor value
        alias: *myanchor
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'forbid-duplicated-anchors' do
    let(:rule) do
      described_class.new({ 'forbid-undeclared-aliases': false, 'forbid-duplicated-anchors': true,
                            'forbid-unused-anchors': false })
    end

    it 'detects duplicate anchors' do
      content = "first: &anchor value1\nsecond: &anchor value2\n"
      context = build_context(content)
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('duplicate anchor'))
    end

    it 'accepts unique anchors' do
      content = <<~YAML
        first: &anchor1 value1
        second: &anchor2 value2
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'forbid-unused-anchors' do
    let(:rule) do
      described_class.new({ 'forbid-undeclared-aliases': false, 'forbid-duplicated-anchors': false,
                            'forbid-unused-anchors': true })
    end

    it 'detects unused anchor' do
      content = <<~YAML
        key: &unused value
        other: data
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems.map(&:message)).to include(a_string_including('undefined anchor'))
    end

    it 'accepts used anchor' do
      content = <<~YAML
        key: &used value
        alias: *used
      YAML
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'with invalid YAML' do
    let(:rule) { described_class.new }

    it 'handles syntax errors gracefully' do
      content = "key: [\n"
      context = build_context(content)
      problems = rule.check(context)

      expect(problems).to be_an(Array)
    end
  end
end
