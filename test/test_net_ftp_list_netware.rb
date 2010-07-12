require 'test/unit'
require 'net/ftp/list'

class TestNetFTPListNetware < Test::Unit::TestCase

  def setup
    @dir  = Net::FTP::List.parse('d [RWCEAFMS] dpearce                          512 Jun 27 23:46 public.www')
    @file = Net::FTP::List.parse('- [RWCEAFMS] dpearce                         2767 Jun 22 06:22 about.html')
  end

  def test_parse_new
    assert_instance_of Net::FTP::List::Netware, @dir, 'LIST Netware directory'
    assert_instance_of Net::FTP::List::Netware, @file, 'LIST Netware file'
  end

  def test_rubbish_lines
    assert_instance_of Net::FTP::List::Unknown, Net::FTP::List.parse("++ bah! ++")
  end

  def test_ruby_netware_mtime
    assert_equal @dir.mtime, Time.parse('Jun 27 23:46')
    assert_equal @file.mtime, Time.parse('Jun 22 06:22')
  end
  
  def test_ruby_netware_like_dir
    assert_equal 'public.www', @dir.basename
    assert @dir.dir?
    assert !@dir.file?
  end

  def test_ruby_netware_like_file
    assert_equal 'about.html', @file.basename
    assert @file.file?
    assert !@file.dir?
  end

end
