require 'test/unit'
require 'net/ftp/list'

class TestNetFTPEntry < Test::Unit::TestCase

  def test_equality
    a = Net::FTP::List::Entry.new('foo1', {:basename => 'foo1'})
    b = Net::FTP::List::Entry.new('foo2', {:basename => 'foo2'})
    c = Net::FTP::List::Entry.new('foo1', {:basename => 'foo1'})

    assert a.eql? c
    assert a.eql? a
    assert !a.eql?(b)
    assert !a.eql?(1)
    assert !a.eql?(1.0)
  end

  def test_comparison
    raw1 = '-rw-r--r-- 1 root     other     1 Dec 31 23:59 file1'
    raw2 = '-rw-r--r-- 1 root     other     2 Dec 31 23:59 file2'
    raw3 = '-rw-r--r-- 1 root     other     3 Dec 31 23:59 file3'

    file1 = Net::FTP::List.parse(raw1)
    file2 = Net::FTP::List.parse(raw2)
    file3 = Net::FTP::List.parse(raw3)

    assert file2 > file1
    assert file2 >= file1
    assert file2 == file2
    assert file2 <= file3
    assert file2 < file3
    assert !(file2 < file1)
    assert !(file2 <= file1)
    assert !(file2 == file1)
    assert !(file2 == file3)
    assert !(file2 > file3)
    assert !(file2 >= file3)

    assert !(file2 < 2)
    assert !(file2 < 2.0)
    assert file2 <= 2
    assert file2 <= 2.0
    assert file2 == 2
    assert file2 == 2.0
    assert !(file2 > 2)
    assert !(file2 > 2.0)
    assert file2 >= 2
    assert file2 >= 2.0

    assert_raise(ArgumentError) { assert file2 > nil }
    assert_raise(ArgumentError) { assert file2 > true } # wrong class
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
