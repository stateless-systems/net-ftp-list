require 'net/ftp'

module Net::FTP::List
  require 'net/ftp/list/parser'
  require 'net/ftp/list/entry'

  # Parser classes should be listed top to bottom, the most specific
  # (and rare!) server variations coming last
  require 'net/ftp/list/unix'
  require 'net/ftp/list/microsoft'
  require 'net/ftp/list/netware'
  require 'net/ftp/list/rumpus'
  require 'net/ftp/list/unknown'

  def self.raise_on_failed_server_detection=(new_flag)
    Thread.current[:net_ftp_list_raise_on_failed_server_detection] = !!new_flag
  end

  def self.raise_on_failed_server_detection
    Thread.current[:net_ftp_list_raise_on_failed_server_detection]
  end

  # Parse a line from FTP LIST responsesa and return a Net::FTP::List::Entry
  def self.parse(*args, **opts)
    Parser.parsers.each do |parser|
      entry = parser.parse(*args, **opts)
      return entry if entry
    end
  end

  # Gets raised with raise_on_failed_server_detection set
  class ParseError < RuntimeError
  end
end
