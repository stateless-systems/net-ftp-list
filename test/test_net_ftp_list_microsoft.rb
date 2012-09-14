require 'test/unit'
require 'net/ftp/list'

class TestNetFTPListMicrosoft < Test::Unit::TestCase

  def setup
    @dir  = Net::FTP::List.parse('06-25-07  01:08PM       <DIR>          etc')
    @file = Net::FTP::List.parse('11-27-07  08:45PM                23437 README.TXT')
  end

  def test_parse_new
    assert_equal "Microsoft", @dir.server_type, 'LIST M$ directory'
    assert_equal "Microsoft", @file.server_type, 'LIST M$ directory'
  end

  def test_parse_mm_dd_yy
    mm_dd_yyyy = nil
    assert_nothing_raised do
      mm_dd_yyyy = Net::FTP::List.parse('06-25-07  01:08PM       <DIR>          etc')
    end
    assert_equal mm_dd_yyyy.mtime.strftime('%Y-%m-%d'), '2007-06-25'
  end

  def test_parse_slash_delimited_date
    slash_delimited = nil
    assert_nothing_raised do
      slash_delimited = Net::FTP::List.parse('06-25-07  01:08PM       <DIR>          etc')
    end
    assert_equal slash_delimited.mtime.strftime('%Y-%m-%d'), '2007-06-25'
  end

  def test_parse_colon_delimited_date
    colon_delimited = nil
    assert_nothing_raised do
      colon_delimited = Net::FTP::List.parse('06-25-07  01:08PM       <DIR>          etc')
    end
    assert_equal colon_delimited.mtime.strftime('%Y-%m-%d'), '2007-06-25'
  end

  def test_rubbish_lines
    assert_instance_of Net::FTP::List::Entry, Net::FTP::List.parse("++ bah! ++")
  end

  def test_ruby_microsoft_mtime
    assert_equal DateTime.strptime('06-25-07  01:08PM', "%m-%d-%y  %I:%M%p"), @dir.mtime
    assert_equal DateTime.strptime('11-27-07  08:45PM', "%m-%d-%y  %I:%M%p"), @file.mtime
  end

  def test_ruby_microsoft_like_dir
    assert_equal 'etc', @dir.basename
    assert @dir.dir?
    assert !@dir.file?
  end

  def test_ruby_microsoft_like_file
    assert_equal 'README.TXT', @file.basename
    assert @file.file?
    assert !@file.dir?
  end

  def test_filesize
    assert_equal 0, @dir.filesize
    assert_equal 23437, @file.filesize
  end

  def test_zero_hour
    file = Net::FTP::List.parse('10-15-09  00:34AM       <DIR>          aspnet_client')
    assert_equal 1255566840.to_s, file.mtime.strftime('%s')
  end
end
