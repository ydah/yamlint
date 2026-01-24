# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

YARD::Rake::YardocTask.new do |task|
  task.files = ['lib/**/*.rb']
  task.options = ['--output-dir', 'docs']
end

task default: %i[spec rubocop]
