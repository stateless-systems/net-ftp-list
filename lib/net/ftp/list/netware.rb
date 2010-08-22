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
  REGEXP = %r!^
    (d|-){1}\s+
    \[(.*?)\]\s+
    (\S+)\s+(\d+)\s+
    (\S+\s+\S+\s+((\d+:\d+)|(\d{4})))
    \s+(.*)
  $!x
  
  # Parse a Netware like FTP LIST entries.
  def self.parse(raw)
    match = REGEXP.match(raw.strip) or return false
    
    is_dir = match[1] == 'd'
    
    emit_entry(
      raw,
      :mtime => Time.parse(match[5]),
      :filesize => match[4].to_i,
      :dir => is_dir, 
      :file => !is_dir,
      :basename => match[9]
    )
  end
end