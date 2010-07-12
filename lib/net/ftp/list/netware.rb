require 'net/ftp/list/parser'
require 'time'

module Net
  class FTP
    module List

      # Parse Netware like FTP LIST entries.
      #
      # == MATCHES
      #
      #   d [RWCEAFMS] dpearce                          512 Jun 27 23:46 public.www
      #
      # == SYNOPSIS
      #
      #   entry = Net::FTP::List::Netware.new('d [RWCEAFMS] dpearce             512 Jun 27 23:46 public.www')
      #   entry.dir?     # => true
      #   entry.basename # => 'public.www'
      class Netware < Parser

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
        def initialize(raw)
          super(raw)
          match = REGEXP.match(raw.strip) or raise ParserError
          
          @mtime = Time.parse(match[5])

          if match[1] == 'd'
            @dir = true
          else
            @file = true
          end

          # TODO: Permissions, users, groups, date/time.

          @basename = match[9]
        end
      end

    end
  end
end
