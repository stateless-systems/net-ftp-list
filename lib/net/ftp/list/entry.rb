# Represents an entry of the FTP list. Gets returned when you parse a list.
class Net::FTP::List::Entry
  include Comparable

  ALLOWED_ATTRIBUTES = [:raw, :basename, :dir, :file, :symlink, :mtime, :filesize, :device, :server_type] #:nodoc:

  # Create a new entry object. The additional argument is the list of metadata keys
  # that can be used on the object. By default just takes and set the raw list entry.
  #   Net::FTP::List.parse(raw_list_string) # => Net::FTP::List::Parser instance.
  def initialize(raw_ls_line, optional_attributes = {}) #:nodoc:
    @raw = raw_ls_line.force_encoding('utf-8')
    optional_attributes.each_pair do |key, value|
      raise ArgumentError, "#{key} is not supported" unless ALLOWED_ATTRIBUTES.include?(key)
      instance_variable_set("@#{key}", value.respond_to?(:force_encoding) ? value.force_encoding('utf-8') : value)
    end
  end

  # Tests for objects equality (value and type).
  #
  # @param entry [Net::FTP::List::Entry] an entry of the FTP list.
  #
  # @return [true, false] true if the objects are equal and have the same type; false otherwise.
  #
  def eql?(other)
    return false if !other.instance_of? self.class
    return true if self.object_id == other.object_id

    self.raw == other.raw # if it's exactly the same line then the objects are the same
  end


  # Compares the receiver against another object.
  #
  # @param (see #eql?)
  #
  # @return [Fixnum]  -1, 0, or +1 depending on whether the receiver is less than, equal to, or greater than the other object.
  #
  def <=>(other)
    if other.instance_of? self.class
      return self.filesize <=> other.filesize
    elsif other.instance_of? Fixnum or other.instance_of? Integer or other.instance_of? Float
      return self.filesize <=> other
    end
    raise ArgumentError.new('comparison of %s with %s failed!' % [self.class, other.class])
  end

  # The raw list entry string.
  def raw
    @raw ||= ''
  end
  alias_method :to_s, :raw

  # The items basename (filename).
  def basename
    @basename ||= ''
  end
  alias name basename

  # Looks like a directory, try CWD.
  def dir?
    !!(@dir ||= false)
  end
  alias directory? dir?

  # Looks like a file, try RETR.
  def file?
    !!(@file ||= false)
  end

  # Looks like a symbolic link.
  def symlink?
    !!(@symlink ||= false)
  end

  # Looks like a device.
  def device?
    !!(@device ||= false)
  end

  # Returns the modification time of the file/directory or the current time if unknown
  def mtime
    @mtime || Time.now
  end

  # Returns the filesize of the entry or 0 for directorties
  def filesize
    @filesize || 0
  end
  alias size filesize

  # Returns the detected server type if this entry
  def server_type
    @server_type || "Unknown"
  end

  def unknown?
    @dir.nil? && @file.nil? && @symlink.nil? && @device.nil?
  end
end
