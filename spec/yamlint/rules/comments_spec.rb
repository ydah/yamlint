# frozen_string_literal: true

RSpec.describe Yamlint::Rules::Comments do
  describe 'require-starting-space' do
    let(:rule) { described_class.new({ 'require-starting-space': true }) }

    it 'detects missing space after #' do
      context = build_context("#no space\n")
      problems = rule.check(context)

      expect(problems.any? { |p| p.message.include?('missing starting space') }).to be(true)
    end

    it 'accepts space after #' do
      context = build_context("# has space\n")
      problems = rule.check(context)

      space_problems = problems.select { |p| p.message.include?('starting space') }
      expect(space_problems).to be_empty
    end

    it 'ignores shebangs by default' do
      rule_with_shebang = described_class.new({ 'require-starting-space': true, 'ignore-shebangs': true })
      context = build_context("#!/bin/bash\nkey: value\n")
      problems = rule_with_shebang.check(context)

      expect(problems).to be_empty
    end
  end

  describe 'min-spaces-from-content' do
    let(:rule) { described_class.new({ 'min-spaces-from-content': 2 }) }

    it 'detects insufficient space before inline comment' do
      context = build_context("key: value # comment\n")
      problems = rule.check(context)

      space_problems = problems.select { |p| p.message.include?('too few spaces before comment') }
      expect(space_problems.length).to eq(1)
    end

    it 'accepts sufficient space before inline comment' do
      context = build_context("key: value  # comment\n")
      problems = rule.check(context)

      space_problems = problems.select { |p| p.message.include?('before comment') }
      expect(space_problems).to be_empty
    end

    it 'ignores standalone comments' do
      context = build_context("# standalone comment\nkey: value\n")
      problems = rule.check(context)

      space_problems = problems.select { |p| p.message.include?('before comment') }
      expect(space_problems).to be_empty
    end
  end

  describe '#fixable?' do
    let(:rule) { described_class.new }

    it 'returns true' do
      expect(rule.fixable?).to be(true)
    end
  end
end
