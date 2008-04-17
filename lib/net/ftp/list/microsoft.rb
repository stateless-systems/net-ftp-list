require 'net/ftp/list/parser'

module Net
  class FTP
    module List

      # Parse Microsoft(NT) like FTP LIST entries.
      #
      # == MATCHES
      #
      #   06-25-07  01:08PM       <DIR>          etc
      #   11-27-07  08:45PM                23437 README.TXT
      #
      # == SYNOPSIS
      #
      #   entry = Net::FTP::List::Microsoft.new('06-25-07  01:08PM       <DIR>          etc')
      #   entry.dir?     # => true
      #   entry.basename # => 'etc'
      class Microsoft < Parser

        # Stolen straight from the ASF's commons Java FTP LIST parser library.
        # http://svn.apache.org/repos/asf/commons/proper/net/trunk/src/java/org/apache/commons/net/ftp/
        REGEXP = %r{
          ^\s*
          (\S+)\s+(\S+)\s+
          (?:(<DIR>)|([0-9]+))\s+
          (\S.*)
          \s*$
        }x

        # Parse a Microsoft(NT) like FTP LIST entries.
        def initialize(raw)
          super(raw)
          match = REGEXP.match(raw.strip) or raise ParserError

          if match[3] == '<DIR>'
            @dir = true
          else
            @file = true
          end

          # TODO: Permissions, users, groups, date/time.

          @basename = match[5]
        end
      end

    end
  end
end
