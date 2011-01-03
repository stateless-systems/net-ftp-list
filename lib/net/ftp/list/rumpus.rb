require 'net/ftp/list/parser'

# Parse Rumpus FTP LIST entries.
#
# == MATCHES
# drwxr-xr-x               folder        0 Nov 30 10:03 houdini
# -rw-r--r--        0      101426   101426 Jun  7  2008 imap with spaces.rb
class Net::FTP::List::Rumpus < Net::FTP::List::Parser

  REGEXP = %r!^
    ([drwxr-]{10})\s+
    (folder|0\s+\d+)\s+
    (\d+)\s+
    (\w+)\s+
    (\d{1,2})\s+
    (\d{2}:\d{2}|\d{4})\s+
    (.+)
  $!x

  # Parse a Rumpus FTP LIST entry.
  def self.parse(raw)
    match = REGEXP.match(raw.strip) or return false

    emit_entry(
      raw,
      :basename => match[7],
      :mtime => Time.parse([match[4], match[5], match[6]].join(" ")),
      :file => !(match[2] == "folder"),
      :dir => (match[2] == "folder"),
      :filesize => match[3].to_i
    )
  end
end
