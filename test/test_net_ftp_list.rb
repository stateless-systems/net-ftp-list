require 'test/unit'
require 'net/ftp/list'

class TestNetFTPList < Test::Unit::TestCase

  def setup
    @dir  = Net::FTP::List.new('drwxr-xr-x   4 user     group       4096 Dec 10 20:23 etc')
    @file = Net::FTP::List.new('-rw-r--r--   1 root     other        531 Jan 29 03:26 README')
  end

  def test_parse_new
    assert_instance_of Net::FTP::List, @dir, 'LIST unixish directory'
    assert_instance_of Net::FTP::List, @file, 'LIST unixish file'
  end

  def test_rubbish_lines
    assert_raise RuntimeError do
      Net::FTP::List.new("++ bah! ++")
      Net::FTP::List.new("drwxr-x--x   5 sstest   pg544526     4096 Dec 10 20:22 .")
    end
  end

  def test_ext_unix_like_dir
    assert_equal @dir.name, 'etc'
    assert_equal @dir.flagtrycwd, 1
    assert_equal @dir.flagtryretr, 0
  end

  def test_ruby_unix_like_dir
    assert @dir.dir?
    assert !@dir.file?
  end

  def test_ext_unix_like_file
    assert_equal @file.name, 'README'
    assert_equal @file.flagtrycwd, 0
    assert_equal @file.flagtryretr, 1
  end

  def test_ruby_unix_like_file
    assert @file.file?
    assert !@file.dir?
  end

end
