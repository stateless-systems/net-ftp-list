require 'net/ftp/list/parser'
require 'time'

module Net
  class FTP
    module List
      # Parse Rumpus FTP LIST entries.
      #
      # == MATCHES
      # drwxr-xr-x               folder        0 Nov 30 10:03 houdini
      # -rw-r--r--        0      101426   101426 Jun  7  2008 imap with spaces.rb
      class Rumpus < Parser
        
        REGEXP = %r!^
          ([drwxr-]{10})\s+
          (folder|0\s+\d+)\s+
          (\d+)\s+
          (\w+)\s+
          (\d{1,2})\s+
          (\d{2}:\d{2}|\d{4})\s+
          (.+)
        $!x
        
        # Parse a Netware like FTP LIST entries.
        def initialize(raw)
          super(raw)
          match = REGEXP.match(raw.strip) or raise ParserError
          
          m = match[1], match[2], match[3], match[4], match[5], match[6], match[7]
          @basename = match[7]
          @mtime = Time.parse([match[4], match[5], match[6]].join(" "))
          @file = !(match[2] == "folder")
          @dir = (match[2] == "folder")
          @filesize = match[3].to_i
        end
      end
    end
  end
end
