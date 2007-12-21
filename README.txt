Net::Ftp::List
    by Stateless Systems
    http://statelesssystems.com

== DESCRIPTION

Ruby extension to Dan Bersteins ftpparse C lib to parse FTP LIST responses.

According to the FTP RFC the LIST command "information on a file may vary widely from system to system, this
information may be hard to use automatically in a program, but may be quite useful to a human user".
Unfortunately the NLST command "intended to return information that can be used by a program to further process
the files automatically" only returns the filename and no other information. If you want to know to know even
simple things like 'is the NLST entry a directory or file' you are left with the choice of attempting to CWD to
(and back from) each entry or parsing the LIST command. This extension is an attempt at parsing the LIST command
and as such is subject to all the variability that results from such an undertaking, take responses with a grain
of salt and expect failures.

See the RFC for more guff on LIST and NLST: http://www.ietf.org/rfc/rfc0959.txt

From Dan Bernstein's ftpparse page at http://cr.yp.to/ftpparse.html

---

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

---

== TODO & PROBLEMS

* I'm new to Ruby and C, I'm sure some exist :)
* Dan's requirement that you tell him when you use ftpparse in commercial software is fine, his choice, but I find it
  annoying. It would be nice to replace the C with pure Ruby since I really only chose the C extension since I didn't
  have time to write something myself. With more time an OO'd approach much like the apache projects common FTP LIST
  parser implementation (minus all the Java-ness):
  
  http://svn.apache.org/viewvc/commons/proper/net/trunk/src/java/org/apache/commons/net/ftp/

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

From Dan Bernstein's ftpparse page:

---

Commercial use of ftpparse is fine, as long as you let me know what programs
you're using it in.

---

(The MIT License)

Copyright (c) 2007 Stateless Systems

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
