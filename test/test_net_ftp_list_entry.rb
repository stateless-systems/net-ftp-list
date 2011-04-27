require 'test/unit'
require 'net/ftp/list'

class TestNetFTPEntry < Test::Unit::TestCase

  def test_equality
    a = Net::FTP::List::Entry.new('foo1', {:basename => 'foo1'})
    b = Net::FTP::List::Entry.new('foo2', {:basename => 'foo2'})
    c = Net::FTP::List::Entry.new('foo1', {:basename => 'foo1'})

    assert_equal a, c
    assert_equal a, a
    assert_not_equal a, b
    assert_not_equal a, 1
    assert_not_equal a, 1.0
  end

  def test_raise_on_unknown_options
    assert_raise(ArgumentError) { Net::FTP::List::Entry.new("foo", {:bar => "baz"}) }
  end

  def test_default_values
    e = Net::FTP::List::Entry.new('')
    assert_equal 0, e.filesize
    assert_equal 0, e.size
    assert_equal '', e.basename
    assert_equal '', e.name
    assert e.unknown?
    assert !e.dir?
    assert !e.directory?
    assert !e.file?
    assert !e.symlink?
    assert_kind_of Time, e.mtime
    assert_equal "Unknown", e.server_type
  end

end
