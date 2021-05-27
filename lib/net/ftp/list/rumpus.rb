require 'net/ftp/list/parser'

# Parse Rumpus FTP LIST entries.
#
# == MATCHES
# drwxr-xr-x               folder        0 Nov 30 10:03 houdini
# -rw-r--r--        0      101426   101426 Jun  7  2008 imap with spaces.rb
class Net::FTP::List::Rumpus < Net::FTP::List::Parser
  REGEXP = /^
    ([drwx-]{10})\s+
    (folder|0\s+\d+)\s+
    (\d+)\s+
    (\w+)\s+
    (\d{1,2})\s+
    (\d{2}:\d{2}|\d{4})\s+
    (.+)
  $/x.freeze

  # Parse a Rumpus FTP LIST entry.
  def self.parse(raw, timezone: :utc)
    match = REGEXP.match(raw.strip) or return false
    type  = match[2] == 'folder' ? :dir : :file

    emit_entry(
      raw,
      basename: match[7],
      mtime: parse_time(match[4..6].join(' '), timezone: timezone),
      type: type,
      filesize: match[3].to_i,
    )
  end
end
