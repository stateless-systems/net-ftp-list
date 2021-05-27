Gem::Specification.new do |s|
  s.name = 'net-ftp-list'
  s.version = '3.4.0'
  s.authors = ['Stateless Systems']
  s.email = 'enquiries@statelesssystems.com'
  s.summary = 'Parse FTP LIST command output.'
  s.homepage = 'http://github.com/stateless-systems/net-ftp-list'
  s.license = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject {|f| f.start_with?('test/') }
  s.test_files    = `git ls-files -z -- test/*`.split("\x0")
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.5'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop-bsm'
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'timecop'
end
