Net::Ftp::List
    by Shane Hanna
    http://code.statelesssystems.com

== DESCRIPTION

Ruby extension to Dan Bersteins ftpparse C lib to parse FTP LIST responses.

From Dan Bernstein's ftpparse page at http://cr.yp.to/ftpparse.html

---8<--------------------------------------------------------------------------

ftpparse is a library for parsing FTP LIST responses.

ftpparse currently understands the LIST output from any UNIX server,
Microsoft FTP Service, Windows NT FTP Server, VMS, WFTPD, NetPresenz,
NetWare, and MS-DOS. It also supports EPLF, a solution to the
LIST-parsing mess.

ftpparse parses file modification times into time_t, so you can easily
compare them and display them in your favorite format. It lets you
know how precise the time_t is: LOCAL meaning exact with known time
zone (available from EPLF), REMOTEMINUTE meaning unknown time zone and
seconds, or REMOTEDAY meaning unknown time zone and time of day.

To use ftpparse, simply feed each line of LIST output to the
ftpparse() routine, along with a pointer to a struct ftpparse. If
ftpparse() returns 1, you can find a filename and various other useful
information inside the struct ftpparse.

---8<--------------------------------------------------------------------------

== PROBLEMS

I'm new to Ruby and C, I'm sure some exist.

Dan's requirement that you tell him when you use ftpparse in commercial
software is fine but annoying. It'd be nice to replace the C with pure Ruby
since I really only chose the C extension since I didn't have time to write
something myself.

== SYNOPSIS

  require 'net/ftp'
  require 'net/ftp/list'

  ftp = Net::FTP.open('somehost.com', 'user', 'pass')
  ftp.list('/some/path').each do |l|
    # Parse list line. Continue if it can't be parsed.
    list = Net::FTP::List.new(l) rescue next
    puts list.name
  end

== CREDITS

  * Dan Bernstein's ftpparse. http://cr.yp.to/ftpparse.html
  * Documentation from a Python extension. http://c0re.jp/c0de/ftpparse/

== LICENSE

From Dan Bernstein's ftpparse page

---8<--------------------------------------------------------------------------

Commercial use of ftpparse is fine, as long as you let me know what programs
you're using it in.

---8<--------------------------------------------------------------------------

(The MIT License)

Copyright (c) 2007 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
