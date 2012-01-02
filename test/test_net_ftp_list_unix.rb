require 'test/unit'
require 'net/ftp/list'

class TestNetFTPListUnix < Test::Unit::TestCase
  def setup
    @dir  = Net::FTP::List.parse       "drwxr-xr-x 4 user     group    4096 Jan  1 00:00 etc" rescue nil
    @file = Net::FTP::List.parse       "-rw-r--r-- 1 root     other     531 Dec 31 23:59 README" rescue nil
    @other_dir = Net::FTP::List.parse  "drwxr-xr-x 8 1791     600      4096 Mar 11 07:57 forums" rescue nil
    @spaces = Net::FTP::List.parse     'drwxrwxr-x 2 danial   danial     72 May 23 12:52 spaces suck' rescue nil
    @symlink = Net::FTP::List.parse    "lrwxrwxrwx 1 danial   danial      4 Oct 30 15:26 bar -> /etc" rescue nil
    @older_date = Net::FTP::List.parse "-rwxrwxrwx 1 owner    group  154112 Feb 15  2008 participando.xls" rescue nil
    @block_dev = Net::FTP::List.parse  'brw-r----- 1 root     disk   1,   0 Apr 13  2006 ram0' rescue nil
    @char_dev  = Net::FTP::List.parse  'crw-rw-rw- 1 root     root   1,   3 Apr 13  2006 null' rescue nil
    @socket_dev = Net::FTP::List.parse 'srw-rw-rw- 1 root     root        0 Aug 20 14:15 log' rescue nil
    @pipe_dev = Net::FTP::List.parse   'prw-r----- 1 root     adm         0 Nov 22 10:30 xconsole' rescue nil
  end

  def test_parse_new
    assert_equal "Unix", @dir.server_type, 'LIST unixish directory'
    assert_equal "Unix", @file.server_type, 'LIST unixish file'
    assert_equal "Unix", @other_dir.server_type, 'LIST unixish directory'
    assert_equal "Unix", @spaces.server_type, 'LIST unixish directory with spaces'
    assert_equal "Unix", @symlink.server_type, 'LIST unixish symlink'
    assert_equal "Unix", @block_dev.server_type, 'LIST unix block device'
    assert_equal "Unix", @char_dev.server_type, 'LIST unix char device'
    assert_equal "Unix", @socket_dev.server_type, 'LIST unix socket device'
    assert_equal "Unix", @pipe_dev.server_type, 'LIST unix socket device'
  end

  class ::Time
    class << self
      def time_travel(time)
        @traveled_to_time = time

        begin
          yield
        ensure
          @traveled_to_time = nil
        end
      end

      alias_method :original_now, :now
      def now
        @traveled_to_time || original_now
      end
    end
  end

  # mtimes in the past, same year.
  def test_ruby_unix_like_date_past_same_year
    Time.time_travel(Time.new(2009, 1, 1)) do
      assert_equal Time.new(2009, 1, 1), Net::FTP::List.parse(@dir.raw).mtime
    end
    Time.time_travel(Time.new(2008, 4, 1)) do
      assert_equal Time.new(2008, 3, 11, 7, 57), Net::FTP::List.parse(@other_dir.raw).mtime
    end
  end

  # mtimes in the past, previous year
  def test_ruby_unix_like_date_past_previous_year
    Time.time_travel(Time.new(2008, 2, 4)) do
      assert_equal Time.new(2007, 10, 30, 15, 26), Net::FTP::List.parse(@symlink.raw).mtime
    end
  end

  # mtime in the future.
  def test_ruby_unix_like_date_future
    Time.time_travel(Time.new(2006, 3, 1)) do
      assert_equal Time.new(2006, 4, 13), Net::FTP::List.parse(@char_dev.raw).mtime
    end
  end

  # Parsed during a leap year.
  def test_ruby_unix_like_date_leap_year
    Time.time_travel(Time.new(2012, 1, 2)) do
      assert_equal Time.new(2011, 10, 30, 15, 26), Net::FTP::List.parse(@symlink.raw).mtime
    end
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

  def test_unix_block_device
    assert_equal 'ram0', @block_dev.basename
    assert @block_dev.device?
  end

  def test_unix_char_device
    assert_equal 'null', @char_dev.basename
    assert @char_dev.device?
  end

  def test_unix_socket_device
    assert_equal 'log', @socket_dev.basename
    assert @socket_dev.device?
  end

  def test_unix_pipe_device
    assert_equal 'xconsole', @pipe_dev.basename
    assert @pipe_dev.device?
  end
end
