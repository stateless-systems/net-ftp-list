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
    @@parsers.push(klass)
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
