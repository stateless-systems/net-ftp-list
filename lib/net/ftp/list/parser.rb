require 'date'

# Abstract FTP LIST parser. It really just defines and documents the interface.
class Net::FTP::List::Parser
  class << self
    # Returns registered parsers.
    def parsers
      @parsers ||= []
    end

    # Manuall register a parser.
    def register(parser)
      parsers.push(parser) unless parsers.include?(parser)
    end

    # Automatically add an inheriting parser to the list of known parsers.
    def inherited(klass)
      super
      register(klass)
    end

    # The main parse method. Return false from it if parsing fails (this is cheaper than raising an exception)
    def parse(_raw, **)
      false
    end

    private

    # Automatically adds the name of the parser class to the server_type field
    def emit_entry(raw, **extra)
      Net::FTP::List::Entry.new raw, **extra, server_type: to_s.split('::').pop
    end

    def parse_time(str, timezone:, format: nil)
      case timezone
      when :utc
        (format ? DateTime.strptime(str, format) : DateTime.parse(str)).to_time
      when :local
        format ? Time.strptime(str, format) : Time.parse(str)
      else
        raise ArgumentError, "invalid timezone #{timezone}, only :utc and :local are allowed"
      end
    end
  end
end
