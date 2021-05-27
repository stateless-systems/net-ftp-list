require 'net/ftp/list/parser'
require 'time'

# Parse Netware like FTP LIST entries.
#
# == MATCHES
#
#   d [RWCEAFMS] dpearce                          512 Jun 27 23:46 public.www
class Net::FTP::List::Netware < Net::FTP::List::Parser
  # Stolen straight from the ASF's commons Java FTP LIST parser library.
  # http://svn.apache.org/repos/asf/commons/proper/net/trunk/src/java/org/apache/commons/net/ftp/
  REGEXP = /^
    (d|-){1}\s+
    \[(.*?)\]\s+
    (\S+)\s+(\d+)\s+
    (\S+\s+\S+\s+((\d+:\d+)|(\d{4})))
    \s+(.*)
  $/x.freeze

  # Parse a Netware like FTP LIST entries.
  def self.parse(raw, timezone: :utc)
    match = REGEXP.match(raw.strip) or return false
    type  = match[1] == 'd' ? :dir : :file

    emit_entry(
      raw,
      mtime: parse_time(match[5], timezone: timezone),
      filesize: match[4].to_i,
      type: type,
      basename: match[9],
    )
  end
end
