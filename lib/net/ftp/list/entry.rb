# Represents an entry of the FTP list. Gets returned when you parse a list.
class Net::FTP::List::Entry

  ALLOWED_ATTRIBUTES = [:raw, :basename, :dir, :file, :symlink, :mtime, :filesize, :device, :server_type] #:nodoc:

  # Create a new entry object. The additional argument is the list of metadata keys
  # that can be used on the object. By default just takes and set the raw list entry.
  #   Net::FTP::List.parse(raw_list_string) # => Net::FTP::List::Parser instance.
  def initialize(raw_ls_line, optional_attributes = {}) #:nodoc:
    @raw = raw_ls_line
    optional_attributes.each_pair do |key, value|
      raise ArgumentError, "#{key} is not supported" unless ALLOWED_ATTRIBUTES.include?(key)
      instance_variable_set("@#{key}", value)
    end
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

  # Looks like a directory, try CWD.
  def dir?
    !!(@dir ||= false)
  end

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

  # Returns the detected server type if this entry
  def server_type
    @server_type || "Unknown"
  end

  def unknown?
    @dir.nil? && @file.nil? && @symlink.nil? && @device.nil?
  end
end
