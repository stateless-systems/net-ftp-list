require 'net/ftp/list/parser'
require 'date'

# Parse Microsoft(NT) like FTP LIST entries.
#
# == MATCHES
#
#   06-25-2007  01:08PM       <DIR>          etc
#   06-25-07    01:08PM       <DIR>          etc
#   11-27-07    08:45PM                23437 README.TXT
class Net::FTP::List::Microsoft < Net::FTP::List::Parser
  REGEXP = %r!
    ^\s*
    ([0-9\-:/]{5,})\s+([0-9\-:]{3,}(?:[aApP][mM])?)\s+
    (?:(<DIR>)|([0-9]+))\s+
    (\S.*)
    \s*$
  !x.freeze

  # Parse a Microsoft(NT) like FTP LIST entries.
  def self.parse(raw, timezone: :utc)
    match = REGEXP.match(raw.strip) or return false

    date_match = /(\d\d).(\d\d).(\d\d(?:\d\d)?)/.match(match[1])
    date_format = date_match[1].to_i > 12 ? '%d-%m-%y' : '%m-%d-%y'
    date_format.sub!(/%y/, '%Y') if date_match[3].length > 2

    unless /-/.match?(match[1])
      date_format.tr!('-', '/') if %r{/}.match?(match[1])
      date_format.tr!('-', ':') if /:/.match?(match[1])
    end

    mtime = parse_time("#{match[1]} #{match[2]}", format: "#{date_format} %H:%M%p", timezone: timezone)
    type  = match[3] == '<DIR>' ? :dir : :file

    emit_entry(
      raw,
      type: type,
      filesize: match[4].to_i,
      basename: match[5],
      mtime: mtime,
    )
  end
end
