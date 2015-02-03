require 'rake/testtask'
require 'bundler'

Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.pattern = ENV['TEST_PATTERN'] || "test/**/*_spec.rb"
end

task :default => :test
