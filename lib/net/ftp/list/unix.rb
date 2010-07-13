require 'time'
require 'net/ftp/list/parser'

module Net
  class FTP
    module List

      # Parse Unix like FTP LIST entries.
      #
      # == MATCHES
      # 
      #   drwxr-xr-x   4 steve    group       4096 Dec 10 20:23 etc
      #   -rw-r--r--   1 root     other        531 Jan 29 03:26 README.txt
      #
      # == SYNOPSIS
      #
      #   entry = Net::FTP::List::Unix.new('drwxr-xr-x   4 steve    group       4096 Dec 10 20:23 etc')
      #   entry.dir?     # => true
      #   entry.basename # => 'etc'
      class Unix < Parser

        # Stolen straight from the ASF's commons Java FTP LIST parser library.
        # http://svn.apache.org/repos/asf/commons/proper/net/trunk/src/java/org/apache/commons/net/ftp/
        REGEXP = %r{
          ([bcdlfmpSs-])
          (((r|-)(w|-)([xsStTL-]))((r|-)(w|-)([xsStTL-]))((r|-)(w|-)([xsStTL-])))\+?\s+
          (\d+)\s+
          (\S+)\s+
          (?:(\S+(?:\s\S+)*)\s+)?
          (\d+)\s+
          ((?:\d+[-/]\d+[-/]\d+)|(?:\S+\s+\S+))\s+
          (\d+(?::\d+)?)\s+
          (\S*)(\s*.*)
        }x

        # Parse a Unix like FTP LIST entries.
        def initialize(raw)
          super(raw)
          match = REGEXP.match(raw.strip) or raise ParserError

          case match[1]
            when /d/    then @dir = true
            when /l/    then @symlink = true
            when /[f-]/ then @file = true
            when /[bc]/ then # Do nothing with devices for now.
            else ParserError 'Unknown LIST entry type.'
          end

          # TODO: Permissions, users, groups, date/time.
          @mtime = Time.parse("#{match[19]} #{match[20]}")

          @basename = match[21].strip

          # filenames with spaces will end up in the last match
          @basename += match[22] unless match[22].nil?

          # strip the symlink stuff we don't care about
          @basename.sub!(/\s+\->.+$/, '') if @symlink
        end
      end

    end
  end
end
