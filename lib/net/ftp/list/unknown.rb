require 'net/ftp/list/parser'

# If all other attempts to parse the entry fail this is the parser that is going to be used.
# It might be a good idea to fail loudly.
class Net::FTP::List::Unknown < Net::FTP::List::Parser
  def self.parse(raw, **)
    raise Net::FTP::List::ParseError, "Could not parse #{raw} since none of the parsers was up to the task" if Net::FTP::List.raise_on_failed_server_detection

    emit_entry(raw)
  end
end
