require 'net/ftp'
require 'net/ftp/list/parser'

# The order here is important for the time being. Corse grained parsers should appear before specializations because
# the whole thing is searched in reverse order.
require 'net/ftp/list/unix'

module Net #:nodoc:
  class FTP #:nodoc:

    alias_method :raw_list, :list
    def list(*args, &block)
      # TODO: Map in void context when you pass a block.
      raw_list(*args).map do |raw|
        entry = Net::FTP::List.parse(raw)
        block ? yield(entry) : entry
      end
    end

    # Parse FTP LIST responses.
    #
    # Simply require the library and each entry from Net::FTP +list+, +ls+ or +dir+ methods will
    # be parsed by the LIST parse as best it can.
    #
    # == Creation
    #
    # By requiring Net::FTP::List instances are created by calling any of Net::FTP's +list+, +ls+ or
    # +dir+ metods. The +to_s+ method still returns the raw line so for the most part this should be
    # transparent.
    #
    #   require 'net/ftp' # Not really required but I like to list dependencies sometimes.
    #   require 'net/ftp/list'
    #
    #   ftp = Net::FTP.open('somehost.com', 'user', 'pass')
    #   ftp.list('/some/path') do |entry|
    #     # Ignore everything that's not a file (so symlinks, directories and devices etc.)
    #     next unless entry.file?
    #
    #     # If entry isn't a kind_of Net::FTP::List::Unknown then there is a bug in Net::FTP::List if this isn't the
    #     # same name as ftp.nlist('/some/path') would have returned.
    #     puts entry.basename
    #   end
    #
    # == Exceptions
    #
    # None at this time. At worst you'll end up with an Net::FTP::List::Unknown instance which won't have any extra
    # useful information. Methods like <tt>dir?</tt>, <tt>file?</tt> and <tt>symlink?</tt> will all return +false+.
    module List
      class << self

        # Parse a raw FTP LIST line.
        #
        #   Net::FTP::List.parse(raw_list_string) # => Net::FTP::List::Parser instance.
        def parse(raw)
          Parser.parse(raw)
        end

        # Parse a raw FTP LIST line.
        #
        # An alias for +parse+.
        alias_method :new, :parse

      end
    end

  end
end
