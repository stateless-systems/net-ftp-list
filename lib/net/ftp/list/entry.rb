# Represents an entry of the FTP list. Gets returned when you parse a list.
class Net::FTP::List::Entry
  include Comparable

  attr_reader :raw, :basename, :type, :filesize, :mtime, :server_type, :symlink_destination
  alias to_s raw
  alias name basename
  alias size filesize

  # Create a new entry object. The additional argument is the list of metadata keys
  # that can be used on the object. By default just takes and set the raw list entry.
  #   Net::FTP::List.parse(raw_list_string) # => Net::FTP::List::Parser instance.
  def initialize(raw_ls_line,
    basename: nil,
    type: nil,
    mtime: nil,
    filesize: nil,
    server_type: nil,
    symlink_destination: nil) #:nodoc:
    @raw = raw_ls_line.respond_to?(:force_encoding) ? raw_ls_line.force_encoding('utf-8') : raw_ls_line
    @basename = basename || ''
    @type = type
    @mtime = mtime || Time.now
    @filesize = filesize || 0
    @server_type = server_type || 'Unknown'
    @symlink_destination = symlink_destination
  end

  # Tests for objects equality (value and type).
  #
  # @param entry [Net::FTP::List::Entry] an entry of the FTP list.
  #
  # @return [true, false] true if the objects are equal and have the same type; false otherwise.
  #
  def eql?(other)
    return false unless other.is_a?(::Net::FTP::List::Entry)
    return true if equal?(other)

    raw == other.raw # if it's exactly the same line then the objects are the same
  end

  # Compares the receiver against another object.
  #
  # @param (see #eql?)
  #
  # @return [Integer]  -1, 0, or +1 depending on whether the receiver is less than, equal to, or greater than the other object.
  #
  def <=>(other)
    case other
    when ::Net::FTP::List::Entry
      return filesize <=> other.filesize
    when Numeric
      return filesize <=> other
    end

    raise ArgumentError, format('comparison of %<self>s with %<other>s failed!', self: self.class, other: other.class)
  end

  # Looks like a directory, try CWD.
  def dir?
    type == :dir
  end
  alias directory? dir?

  # Looks like a file, try RETR.
  def file?
    type == :file
  end

  # Looks like a symbolic link.
  def symlink?
    type == :symlink
  end

  # Looks like a device.
  def device?
    type == :device
  end

  # Is the entry type unknown?
  def unknown?
    !dir? && !file? && !symlink? && !device?
  end
end
