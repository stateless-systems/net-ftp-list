# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{net-ftp-list}
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stateless Systems"]
  s.date = %q{2009-05-05}
  s.email = %q{enquiries@statelesssystems.com}
  s.extra_rdoc_files = [
    "README.txt"
  ]
  s.files = [
    "README.txt",
    "Rakefile",
    "VERSION.yml",
    "lib/net/ftp/list.rb",
    "lib/net/ftp/list/microsoft.rb",
    "lib/net/ftp/list/netware.rb",
    "lib/net/ftp/list/parser.rb",
    "lib/net/ftp/list/unix.rb",
    "test/test_net_ftp_list_microsoft.rb",
    "test/test_net_ftp_list_netware.rb",
    "test/test_net_ftp_list_unix.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/stateless-systems/net-ftp-list}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Parse FTP LIST command output.}
  s.test_files = [
    "test/test_net_ftp_list_unix.rb",
    "test/test_net_ftp_list_netware.rb",
    "test/test_net_ftp_list_microsoft.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
