= Net::Ftp::List

== DESCRIPTION

Ruby lib to parse FTP LIST responses.

According to the FTP RFC the LIST command "information on a file may vary widely from system to system, this
information may be hard to use automatically in a program, but may be quite useful to a human user".
Unfortunately the NLST command "intended to return information that can be used by a program to further process
the files automatically" only returns the filename and no other information. If you want to know to know even
simple things like 'is the NLST entry a directory or file' you are left with the choice of attempting to CWD to
(and back from) each entry or parsing the LIST command. This extension is an attempt at parsing the LIST command
and as such is subject to all the variability that results from such an undertaking, take responses with a grain
of salt and expect failures.

See the RFC for more guff on LIST and NLST: http://www.ietf.org/rfc/rfc0959.txt

== TODO & PROBLEMS

* I'm new to Ruby, I'm sure some exist :)
* The factory and abstract base class for parsers are one and the same. OO geeks will cry.
* More OS's and server types. Only servers that return Unix like LIST responses will work at the moment.
* Calling <tt>if entry.file? or entry.dir?</tt> is hard work when you really mean <tt>unless entry.unknown?</tt>
* I'm not sure about overwriting Net::FTP's +list+, +ls+ and +dir+. It's a base lib after all and people will be
  expecting String. Perhaps I'd be better to <tt>class Parser < String</tt> for the abstract parser.
* The block handling for +list+, +ls+ and +dir+ has a nasty +map+ that's essentially building up an unused Array.

== SYNOPSIS

By requiring Net::FTP::List instances are created by calling any of Net::FTP's <tt>list</tt>, <tt>ls</tt> or
<tt>dir</tt> metods. The <tt>to_s</tt> method still returns the raw line so for the most part this should be
transparent.

  require 'net/ftp' # Not really required but I like to list dependencies sometimes.
  require 'net/ftp/list'

  ftp = Net::FTP.open('somehost.com', 'user', 'pass')
  ftp.list('/some/path') do |entry|
    # Ignore everything that's not a file (so symlinks, directories and devices etc.)
    next unless entry.file?

    # If entry isn't a kind_of Net::FTP::List::Unknown then there is a bug in Net::FTP::List if this isn't the
    # same name as ftp.nlist('/some/path') would have returned.
    puts entry.basename
  end

== CREDITS

  * ASF, Commons. http://commons.apache.org/
  * The good people at Stateless Systems who let me write Ruby and give it away.

== LICENSE

(The MIT License, go nuts)

Copyright (c) 2007 Shane Hanna
Stateless Systems
http://statelesssystems.com

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
