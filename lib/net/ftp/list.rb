require 'netftplist' # The C extension.

module Net
  class FTP
    class List
      # TODO: More rubyish aliases.
      # Perhaps a mixin so for Net::FTP's to return List objects for
      # list, ls and dir.
      alias_method :basename, :name

      def file?
        flagtryretr == 1
      end

      def dir?
        flagtrycwd == 1
      end

      def symlink?
        dir? && file? # Symlinks are marked as try for cwd *and* retr.
      end
    end
  end
end
