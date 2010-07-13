module Net
  class FTP
    module List

      # ParserError
      #
      # Raw entry couldn't be parsed for some reason.
      #
      # == TODO
      #
      # Get more specific with error messages.
      class ParserError < RuntimeError; end

      # Abstract FTP LIST parser.
      #
      # It really just defines and documents the interface.
      #
      # == Exceptions
      #
      # +ParserError+ -- Raw entry could not be parsed.
      class Parser
        @@parsers = []

        # Parse a raw FTP LIST line.
        #
        # By default just takes and set the raw list entry.
        #
        #   Net::FTP::List.parse(raw_list_string) # => Net::FTP::List::Parser instance.
        def initialize(raw)
          @raw = raw
        end

        # The raw list entry string.
        def raw
          @raw ||= ''
        end
        alias_method :to_s, :raw

        # The items basename (filename).
        def basename
          @basename ||= ''
        end

        # Looks like a directory, try CWD.
        def dir?
          !!@dir ||= false
        end

        # Looks like a file, try RETR.
        def file?
          !!@file ||= false
        end

        # Looks like a symbolic link.
        def symlink?
          !!@symlink ||= false
        end

        def mtime
          @mtime
        end

        class << self
          # Acts as a factory.
          #
          # TODO: Having a class be both factory and abstract implementation seems a little nutty to me. If it ends up
          # too confusing or gives anyone the shits I'll move it.
          def inherited(klass) #:nodoc:
            @@parsers << klass
          end

          # Factory method.
          #
          # Attempt to find a parser and parse a list item. At worst the item will return an Net::FTP::List::Unknown
          # instance. This may change in the future so that only parsable entries are kept.
          def parse(raw)
            @@parsers.reverse.each do |parser|
              begin
                return parser.new(raw)
              rescue ParserError
                next
              end
            end
          end
        end

      end

      # Unknown parser.
      #
      # If all other attempts to parse the entry fail this class will be returned. Only the +raw+ and +to_s+
      # methods will return anything useful.
      class Unknown < Parser
      end
    end
  end
end
