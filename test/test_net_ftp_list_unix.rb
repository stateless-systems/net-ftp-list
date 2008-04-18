require 'test/unit'
require 'net/ftp/list'

class TestNetFTPListUnix < Test::Unit::TestCase

  def setup
    @dir  = Net::FTP::List.parse('drwxr-xr-x   4 user     group       4096 Dec 10 20:23 etc')
    @file = Net::FTP::List.parse('-rw-r--r--   1 root     other        531 Jan 29 03:26 README')
    @other_dir = Net::FTP::List.parse('drwxr-xr-x    8 1791     600          4096 Mar 11 07:57 forums')
  end

  def test_parse_new
    assert_instance_of Net::FTP::List::Unix, @dir, 'LIST unixish directory'
    assert_instance_of Net::FTP::List::Unix, @file, 'LIST unixish file'
    assert_instance_of Net::FTP::List::Unix, @other_dir, 'LIST unixish directory'
  end

  def test_rubbish_lines
    assert_instance_of Net::FTP::List::Unknown, Net::FTP::List.parse("++ bah! ++")
  end

  def test_ruby_unix_like_dir
    assert_equal 'etc', @dir.basename
    assert @dir.dir?
    assert !@dir.file?

    assert_equal 'forums', @other_dir.basename
    assert @other_dir.dir?
    assert !@other_dir.file?
  end

  def test_ruby_unix_like_file
    assert_equal 'README', @file.basename
    assert @file.file?
    assert !@file.dir?
  end

end
