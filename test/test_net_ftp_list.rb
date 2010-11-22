require 'test/unit'
require 'net/ftp/list'

class TestNetFTPList < Test::Unit::TestCase

  def test_all
    one = Net::FTP::List.parse("drwxr-xr-x               folder        0 Nov 30 10:03 houdini")
    assert_kind_of Net::FTP::List::Entry, one
    assert one.dir?
    assert !one.file?

    two = Net::FTP::List.parse("++ unknown garbage +++")
    assert_kind_of Net::FTP::List::Entry, two
    assert two.unknown?
    assert_equal '', two.basename
  end

  def test_raise_when_flag_set
    Net::FTP::List.raise_on_failed_server_detection = true
    assert_raise(Net::FTP::List::ParseError) do
      Net::FTP::List.parse("++ unknown garbage +++")
    end
  ensure
    Net::FTP::List.raise_on_failed_server_detection = false
  end
end
