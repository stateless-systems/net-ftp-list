require 'test/unit'
require 'net/ftp/list'

class TestNetFTPListMicrosoft < Test::Unit::TestCase

  def setup
    #                             DATE      TIME          DIR      SIZE  NAME
    @dir  = Net::FTP::List.parse('06-25-07  01:08PM       <DIR>          etc')
    @file = Net::FTP::List.parse('11-27-07  08:45PM                23437 README.TXT')
  end

  def test_parse_new
    assert_instance_of Net::FTP::List::Microsoft, @dir, 'LIST M$ directory'
    assert_instance_of Net::FTP::List::Microsoft, @file, 'LIST M$ file'
  end

  def test_rubbish_lines
    assert_instance_of Net::FTP::List::Unknown, Net::FTP::List.parse("++ bah! ++")
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
    assert @dir.filesize.nil?
    assert_equal 23437, @file.filesize
  end
end
