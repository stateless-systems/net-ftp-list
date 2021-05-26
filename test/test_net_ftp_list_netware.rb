require 'test/unit'
require 'net/ftp/list'

class TestNetFTPListNetware < Test::Unit::TestCase
  def setup
    @dir   = Net::FTP::List.parse('d [RWCEAFMS] dpearce                          512 Jun 27 23:46 public.www')
    @file  = Net::FTP::List.parse('- [RWCEAFMS] dpearce                         2767 Jun 22 06:22 about.html', timezone: :local)
  end

  def test_parse_new
    assert_equal 'Netware', @dir.server_type, 'LIST Netware directory'
    assert_equal 'Netware', @file.server_type, 'LIST Netware file'
  end

  def test_ruby_netware_mtime
    assert_equal Time.utc(Time.now.year, 6, 27, 23, 46), @dir.mtime
    assert_equal Time.local(Time.now.year, 6, 22, 6, 22), @file.mtime
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

  def test_filesize
    assert_equal 512, @dir.filesize
    assert_equal 2767, @file.filesize
  end
end
