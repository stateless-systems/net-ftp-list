require 'net/ftp'
require 'net/ftp/list/parser'

# The order here is important for the time being. Corse grained parsers should appear before specializations because
# the whole thing is searched in reverse order.
require 'net/ftp/list/unix'

module Net #:nodoc:
  class FTP #:nodoc:

    # Parse FTP LIST responses.
    #
    # Mixin the +Net::FTP::List+ module and subsequent calls to the Net::FTP +list+, +ls+ or +dir+ methods will be
    # parsed by the LIST parser as best it can.
    #
    # == Creation
    #
    #   require 'net/ftp' # Not really required but I like to list dependencies sometimes.
    #   require 'net/ftp/list'
    #
    #   ftp = Net::FTP.open('somehost.com', 'user', 'pass')
    #   ftp.extend Net::FTP::List
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

      def self.extended(klass) #:nodoc:
        class << klass
  
          alias_method :raw_list, :list
          def list(*args, &block)
            if block
              raw_list(*args){|raw| yield parse_list_entry(raw)}
            else
              raw_list(*args).map{|raw| parse_list_entry(raw)}
            end
          end

          protected
            # Call the parse with a raw list entry.
            #
            # Handy because it saves you aliasing list() yet again to modify individual entries.
            def parse_list_entry(raw) #:nodoc:
              Net::FTP::List::Parser.parse(raw)
            end
        end
      end

    end

  end
end

