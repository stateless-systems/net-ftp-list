require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'
require 'rubocop/rake_task'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'net-ftp-list'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

RuboCop::RakeTask.new(:rubocop)

task default: %i[rubocop test]
