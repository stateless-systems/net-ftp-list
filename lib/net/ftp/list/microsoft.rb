require 'net/ftp/list/parser'
require 'date'

# Parse Microsoft(NT) like FTP LIST entries.
#
# == MATCHES
#
#   06-25-07  01:08PM       <DIR>          etc
#   11-27-07  08:45PM                23437 README.TXT
class Net::FTP::List::Microsoft < Net::FTP::List::Parser
  # Stolen straight from the ASF's commons Java FTP LIST parser library.
  # http://svn.apache.org/repos/asf/commons/proper/net/trunk/src/java/org/apache/commons/net/ftp/
  REGEXP = %r!
    ^\s*
    ([0-9\-:\/]{5,})\s+([0-9\-:]{3,}(?:[aApP][mM])?)\s+
    (?:(<DIR>)|([0-9]+))\s+
    (\S.*)
    \s*$
  !x

  # Parse a Microsoft(NT) like FTP LIST entries.
  def self.parse(raw)
    match = REGEXP.match(raw.strip) or return false

    mtime = DateTime.strptime("#{match[1]} #{match[2]}", "%m-%d-%y  %H:%M%p")
    is_dir = match[3] == '<DIR>'
    filesize = is_dir ? 0 : match[4].to_i

    emit_entry(
      raw,
      :dir => is_dir,
      :file => !is_dir,
      :filesize => filesize,
      :basename => match[5],
      :mtime => mtime
    )
  end
end
