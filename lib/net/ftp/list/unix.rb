require 'time'
require 'net/ftp/list/parser'

# Parse Unix like FTP LIST entries.
#
# == MATCHES
#
#   drwxr-xr-x   4 steve    group       4096 Dec 10 20:23 etc
#   -rw-r--r--   1 root     other        531 Jan 29 03:26 README.txt
class Net::FTP::List::Unix < Net::FTP::List::Parser
  # Stolen straight from the ASF's commons Java FTP LIST parser library.
  # http://svn.apache.org/repos/asf/commons/proper/net/trunk/src/java/org/apache/commons/net/ftp/
  REGEXP = %r{
    ([pbcdlfmSs-])
    (((r|-)(w|-)([xsStTL-]))((r|-)(w|-)([xsStTL-]))((r|-)(w|-)([xsStTL-])))\+?\s+
    (?:(\d+)\s+)?
    (\S+)?\s+(\S+)?\s+
    (?:\d+,\s+)?
    (\d+)\s+
    ((?:\d+[-/]\d+[-/]\d+)|(?:\S+\s+\S+))\s+
    (\d+(?::\d+)?)\s+
    (\S*)(\s*.*)
  }x.freeze

  ONE_YEAR = (60 * 60 * 24 * 365)

  # Parse a Unix like FTP LIST entries.
  def self.parse(raw, timezone: :utc)
    match = REGEXP.match(raw.strip) or return false
    type  = case match[1]
            when /d/      then :dir
            when /l/      then :symlink
            when /[f-]/   then :file
            when /[psbc]/ then :device
            end
    return false if type.nil?

    # Don't match on rumpus (which looks very similar to unix)
    return false if match[17].nil? && ((match[15].nil? && (match[16].to_s == 'folder')) || (match[15].to_s == '0'))

    # TODO: Permissions, users, groups, date/time.
    filesize = match[18].to_i
    mtime_month_and_day = match[19]
    mtime_time_or_year = match[20]

    # Unix mtimes specify a 4 digit year unless the data is within the past 180
    # days or so. Future dates always specify a 4 digit year.
    # If the parsed date, with today's year, could be in the future, then
    # the date must be for the previous year
    mtime_string = case mtime_time_or_year
                   when /^[0-9]{1,2}:[0-9]{2}$/
                     if parse_time("#{mtime_month_and_day} #{Time.now.year}", timezone: timezone) > Time.now
                       "#{mtime_month_and_day} #{mtime_time_or_year} #{Time.now.year - 1}"
                     else
                       "#{mtime_month_and_day} #{mtime_time_or_year} #{Time.now.year}"
                     end
                   when /^[0-9]{4}$/
                     "#{mtime_month_and_day} #{mtime_time_or_year}"
                   end

    mtime = parse_time(mtime_string, timezone: timezone)
    basename = match[21].strip

    # filenames with spaces will end up in the last match
    basename += match[22] unless match[22].nil?

    # strip the symlink stuff we don't care about
    if type == :symlink
      basename.sub!(/\s+->(.+)$/, '')
      symlink_destination = Regexp.last_match(1).strip if Regexp.last_match(1)
    end

    emit_entry(
      raw,
      type: type,
      filesize: filesize,
      basename: basename,
      symlink_destination: symlink_destination,
      mtime: mtime,
    )
  end
end
