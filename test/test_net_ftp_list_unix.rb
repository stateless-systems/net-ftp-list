require 'test/unit'
require 'net/ftp/list'

class TestNetFTPListUnix < Test::Unit::TestCase

  def setup
    @dir  = Net::FTP::List.parse       'drwxr-xr-x 4 user     group    4096 Dec 10 20:23 etc'
    @file = Net::FTP::List.parse       '-rw-r--r-- 1 root     other     531 Jan 29 03:26 README'
    @other_dir = Net::FTP::List.parse  'drwxr-xr-x 8 1791     600      4096 Mar 11 07:57 forums'
    @spaces = Net::FTP::List.parse     'drwxrwxr-x 2 danial   danial     72 May 23 12:52 spaces suck'
    @symlink = Net::FTP::List.parse    'lrwxrwxrwx 1 danial   danial      4 Apr 30 15:26 bar -> /etc'
    @older_date = Net::FTP::List.parse '-rwxrwxrwx   1 owner    group          154112 Feb 15  2008 participando.xls'
  end

  def test_parse_new
    assert_equal "Unix", @dir.server_type, 'LIST unixish directory'
    assert_equal "Unix", @file.server_type, 'LIST unixish file'
    assert_equal "Unix", @other_dir.server_type, 'LIST unixish directory'
    assert_equal "Unix", @spaces.server_type, 'LIST unixish directory with spaces'
    assert_equal "Unix", @symlink.server_type, 'LIST unixish symlink'
  end
  
  def test_ruby_unix_like_date
    assert_equal Time.parse("Mar 11 07:57"), @other_dir.mtime
    assert_equal Time.parse("Apr 30 15:26"), @symlink.mtime
    assert_equal Time.parse("Feb 15  2008"), @older_date.mtime
  end
  
  def test_ruby_unix_like_dir
    assert_equal 'etc', @dir.basename
    assert @dir.dir?
    assert !@dir.file?
    
    assert_equal 'forums', @other_dir.basename
    assert @other_dir.dir?
    assert !@other_dir.file?
  end
  
  def test_ruby_unix_like_symlink
    assert_equal 'bar', @symlink.basename
    assert @symlink.symlink?
    assert !@symlink.dir?
    assert !@symlink.file?
  end
  
  def test_spaces_in_unix_dir
    assert_equal 'spaces suck', @spaces.basename
    assert @spaces.dir?
    assert !@spaces.file?
  end
  
  def test_ruby_unix_like_file
    assert_equal 'README', @file.basename
    assert @file.file?
    assert !@file.dir?
  end

  def test_filesize
    assert_equal 4096, @dir.filesize
    assert_equal 531, @file.filesize
    assert_equal 4096, @other_dir.filesize
    assert_equal 72, @spaces.filesize
    assert_equal 4, @symlink.filesize
    assert_equal 154112, @older_date.filesize
  end
end
