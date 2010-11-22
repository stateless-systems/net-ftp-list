# Abstract FTP LIST parser. It really just defines and documents the interface.
class Net::FTP::List::Parser

  @@parsers = []

  # Run a passed block with each parser in succession, from the most specific to the least
  # specific. Will return the result of the block.
  def self.with_each_parser(&blk) #:yields: parser
    @@parsers.each(&blk)
  end

  # Automatically add an inheriting parser to the list of known parsers.
  def self.inherited(klass) #:nodoc:
    @@parsers.unshift(klass)
  end

  # The main parse method. Return false from it if parsing fails (this is cheaper than raising an exception)
  def self.parse(raw)
    return false
  end

  private

  # Automatically adds the name of the parser class to the server_type field
  def self.emit_entry(raw, extra_attributes)
    Net::FTP::List::Entry.new raw, extra_attributes.merge(:server_type => to_s.split('::').pop)
  end
end

# If all other attempts to parse the entry fail this is the parser that is going to be used.
# It might be a good idea to fail loudly.
class Net::FTP::List::Unknown < Net::FTP::List::Parser
  def self.parse(raw)
    if Net::FTP::List.raise_on_failed_server_detection
      raise Net::FTP::List::ParseError, "Could not parse #{raw} since none of the parsers was up to the task"
    end

    emit_entry(raw, {})
  end
end
