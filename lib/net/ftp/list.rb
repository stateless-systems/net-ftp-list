require 'netftplist' # The C extension.

module Net #:nodoc:
  class FTP #:nodoc:
    
    # Parse FTP LIST responses.
    #
    # Ruby extension to Dan Bersteins ftpparse C lib to parse FTP LIST responses.
    # Simply feed each entry fom Net::FTP's <tt>list</tt>, <tt>ls</tt> or <tt>dir</tt> methods to the constructor and
    # it'll have a crack at parsing it.
    #
    # == Creation
    # 
    # Hand the constructor a line from the result of an FTP LIST command.
    #
    #   require 'net/ftp'
    #   require 'net/ftp/list'
    #
    #   ftp = Net::FTP.open('somehost.com', 'user', 'pass')
    #   ftp.list('/some/path').each do |l|
    #     # Parse list line. Continue if it can't be parsed.
    #     list = Net::FTP::List.new(l) rescue next
    #     puts list.name
    #   end
    #
    # == Exceptions
    #
    # +RuntimeError+ -- For the time being the only error emitted is a run time error when the line cannot be parsed.
    # This isn't necessarily bad as some lines should be ignored like totals, blank lines and other random human
    # friendly cruft you get from the LIST command.
    class List
      
      # TODO: More rubyish aliases.
      # Perhaps a mixin so for Net::FTP's to return List objects for list, ls and dir.
      
      # The name of the file entry. This is the same name that NLST would return except in the case of symlinks where
      # you will get name as read back by the LIST command (normally in the form of <tt>source -> target</tt>).
      alias_method :basename, :name

      # The entry looks like a file. Try to RETR.
      def file?
        flagtryretr == 1
      end

      # The entry looks like a directory. Try to CWD.
      def dir?
        flagtrycwd == 1
      end

      # The entry looks like a symlink. dir? and file? will also return true for a symlink.
      def symlink?
        dir? && file?
      end
    end
  end
end
