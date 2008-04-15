# -*- ruby -*-
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/testtask'

NAME = 'net-ftp-list'
VERS = '0.7'

CLEAN.include ['**/*.log', '*.gem']
CLOBBER.include ['**/*.log']

spec = Gem::Specification.new do |s|
  s.name             = NAME
  s.version          = VERS
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.txt"]
  s.summary          = 'Parse FTP LIST command output.'
  s.description      = s.summary
  s.author           = 'Shane Hanna'
  s.email            = 'shane@statelesssystems.com'
  s.homepage         = 'http://statelesssystems.com'

  s.files            = FileList['Rakefile', '**/*.{rb,txt}'].to_a
  s.test_files       = FileList['tests/*.rb'].to_a
end

desc 'Default: Run unit tests.'
task :default => :test

Rake::GemPackageTask.new(spec) do |p|
    p.need_tar = true
    p.gem_spec = spec
end

desc 'Run the unit tests.'
Rake::TestTask.new do |t|
  t.verbose = true
end

desc 'Package and install as gem.'
task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/net-ftp-list-#{VERS}}
end

desc 'Uninstall the gem.'
task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
