require 'test/unit'
require 'net/ftp/list'

class TestNetFTPListRumpus < Test::Unit::TestCase
  def setup
    @dir = Net::FTP::List.parse 'drwxrwxrwx               folder        0 Nov 16 22:12 Alias'
    @file = Net::FTP::List.parse '-rw-r--r--        0      101426   101426 Jun  7  2008 imap with spaces.rb', timezone: :local
  end

  def test_parsed
    assert_equal 'Rumpus', @dir.server_type,  'LIST Rumpus directory'
    assert_equal 'Rumpus', @file.server_type, 'LIST Rumpus file with spaces'
  end

  def test_ruby_unix_like_date
    assert_equal Time.utc(Time.now.year, 11, 16, 22, 12), @dir.mtime
    assert_equal Time.local(2008, 6, 7), @file.mtime
  end

  def test_dir
    assert_equal 'Alias', @dir.basename
    assert !@dir.file?
    assert @dir.dir?
  end

  def test_file
    assert_equal 'imap with spaces.rb', @file.basename
    assert @file.file?
    assert !@file.dir?
  end

  def test_filesize
    assert_equal 0, @dir.filesize
    assert_equal 101426, @file.filesize
  end
end
