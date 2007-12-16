require 'mkmf'
exit unless have_header("ftpparse.h")

dir_config('net-ftp-list')
create_makefile('netftplist')
