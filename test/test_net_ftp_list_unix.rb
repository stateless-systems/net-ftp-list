require 'test/unit'
require 'net/ftp/list'
require 'timecop'

class TestNetFTPListUnix < Test::Unit::TestCase
  def parse(*args, **opts)
    Net::FTP::List.parse(*args, **opts)
  end

  def setup
    @dir = parse('drwxr-xr-x 4 user     group    4096 Jan  1 00:00 etc')
    @file = parse('-rw-r--r-- 1 root     other     531 Dec 31 23:59 README')
    @other_dir = parse('drwxr-xr-x 8 1791     600      4096 Mar 11 07:57 forums')
    @spaces = parse('drwxrwxr-x 2 danial   danial     72 May 23 12:52 spaces suck')
    @symlink = parse('lrwxrwxrwx 1 danial   danial      4 Oct 30 15:26 bar -> /etc')
    @empty_symlink = parse('lrwxrwxrwx 1 danial   danial      4 Oct 30 15:26 foo')
    @block_dev = parse('brw-r----- 1 root     disk   1,   0 Apr 13  2006 ram0', timezone: :local)
    @char_dev = parse('crw-rw-rw- 1 root     root   1,   3 Apr 13  2006 null')
    @socket_dev = parse('srw-rw-rw- 1 root     root        0 Aug 20 14:15 log')
    @pipe_dev = parse('prw-r----- 1 root     adm         0 Nov 22 10:30 xconsole')
    @file_no_inodes = parse('-rw-r--r-- foo@utchost foo@utchost  6034 May 14 23:13 index.html')
    @file_today = parse('crw-rw-rw- 1 root     root   1,   3 Aug 16 14:28 today.txt')
    @no_user = parse('-rw-rw----                     2786 Jul  7 01:57 README')
    @older_date = parse('-rwxrwxrwx 1 owner    group  154112 Feb 15  2008 participando.xls')
    @file_with_date = parse('-rw-r--r--   1 tig tig 39757835 Jan 26  2014 PSA 23 99 May-2010.pdf')
  end

  def test_parse_new
    assert_equal 'Unix', @dir.server_type,            'LIST unixish directory'
    assert_equal 'Unix', @file.server_type,           'LIST unixish file'
    assert_equal 'Unix', @other_dir.server_type,      'LIST unixish directory'
    assert_equal 'Unix', @spaces.server_type,         'LIST unixish directory with spaces'
    assert_equal 'Unix', @symlink.server_type,        'LIST unixish symlink'
    assert_equal 'Unix', @empty_symlink.server_type,  'LIST unixish symlink'
    assert_equal 'Unix', @block_dev.server_type,      'LIST unix block device'
    assert_equal 'Unix', @char_dev.server_type,       'LIST unix char device'
    assert_equal 'Unix', @socket_dev.server_type,     'LIST unix socket device'
    assert_equal 'Unix', @pipe_dev.server_type,       'LIST unix socket device'
    assert_equal 'Unix', @file_no_inodes.server_type, 'LIST unixish file with no inodes'
    assert_equal 'Unix', @file_today.server_type,     'LIST unixish file'
    assert_equal 'Unix', @no_user.server_type,        'LIST unixish file with no user/group'
    assert_equal 'Unix', @older_date.server_type,     'LIST unixish file with older date'
    assert_equal 'Unix', @file_with_date.server_type, 'LIST unix with file containing a date'
  end

  # mtimes in the past, same year.
  def test_ruby_unix_like_date_past_same_year
    Timecop.freeze(Time.utc(2009, 1, 1)) do
      assert_equal Time.utc(2009, 1, 1), parse(@dir.raw).mtime
    end
    Timecop.freeze(Time.utc(2008, 4, 1)) do
      assert_equal Time.utc(2008, 3, 11, 7, 57), parse(@other_dir.raw).mtime
    end
  end

  # mtimes in the past, previous year
  def test_ruby_unix_like_date_past_previous_year
    Timecop.freeze(Time.utc(2008, 2, 4)) do
      assert_equal Time.utc(2007, 10, 30, 15, 26), parse(@symlink.raw).mtime
    end
  end

  # mtime in the future.
  def test_ruby_unix_like_date_future
    Timecop.freeze(Time.utc(2006, 3, 1)) do
      assert_equal Time.utc(2006, 4, 13), parse(@char_dev.raw).mtime
    end
  end

  # Parsed during a leap year.
  def test_ruby_unix_like_date_leap_year
    Timecop.freeze(Time.utc(2012, 1, 2)) do
      assert_equal Time.utc(2011, 10, 30, 15, 26), parse(@symlink.raw).mtime
    end
  end

  # mtimes today, same year.
  def test_ruby_unix_like_date_today_same_year
    Timecop.freeze(Time.utc(2013, 8, 16)) do
      assert_equal Time.utc(2013, 8, 16, 14, 28), parse(@file_today.raw).mtime
    end
  end

  def test_basename
    assert_equal 'etc', @dir.basename
    assert_equal 'README', @file.basename
    assert_equal 'forums', @other_dir.basename
    assert_equal 'spaces suck', @spaces.basename
    assert_equal 'bar', @symlink.basename
    assert_equal 'foo', @empty_symlink.basename
    assert_equal 'ram0', @block_dev.basename
    assert_equal 'null', @char_dev.basename
    assert_equal 'log', @socket_dev.basename
    assert_equal 'xconsole', @pipe_dev.basename
    assert_equal 'index.html', @file_no_inodes.basename
    assert_equal 'today.txt', @file_today.basename
    assert_equal 'README', @no_user.basename
    assert_equal 'participando.xls', @older_date.basename
    assert_equal 'PSA 23 99 May-2010.pdf', @file_with_date.basename
  end

  def test_mtime
    assert_equal Time.utc(2008, 2, 15), @older_date.mtime
    assert_equal Time.local(2006, 4, 13), @block_dev.mtime
    assert_equal Time.utc(2014, 1, 26), @file_with_date.mtime
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
    assert_equal '/etc', @symlink.symlink_destination
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

  def test_single_digit_hour
    Timecop.freeze(Time.utc(2014, 8, 16)) do
      single_digit_hour = nil
      assert_nothing_raised do
        single_digit_hour = parse('-rw-r--r-- 1 root     other     531 Dec 31  3:59 README')
      end

      assert_equal Time.utc(2013, 12, 31, 3, 59), single_digit_hour.mtime
    end
  end
end
