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

        # The raw list entry string.
        attr_reader :raw

        # The items basename (filename).
        attr_reader :basename

        # Looks like a directory, try CWD.
        def dir?
          !!self.dir
        end

        # Looks like a file, try RETR.
        def file?
          self.file
        end

        # Looks like a symbolic link.
        def symlink?
          !!self.symlink
        end

        # Parse a raw FTP LIST line.
        #
        # By default just takes and set the raw list entry.
        #
        #   Net::FTP::List.parse(raw_list_string) # => Net::FTP::List::Parser instance.
        def initialize(raw)
          self.raw = raw
        end

        # Stringify.
        def to_s
          raw
        end
        alias_method :raw, :to_s

        class << self

          # Acts as a factory.
          #
          # TODO: Having a class be both factory and abstract implementation seems a little nutty to me. If it ends up
          # too confusing or gives anyone the shits I'll move it.
          def inherited(klass)
            @@parsers << klass
          end

          # Factory method.
          #
          # Attempt to find and parse a list item with the a parser.
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

        protected
          # Protected boolean.
          attr_accessor :file, :dir, :symlink

          # Protected raw list entry string.
          attr_writer :raw

          # Protected item basename (filename).
          attr_writer :basename
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
