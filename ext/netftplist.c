#include <ruby.h>
#include <ftpparse.h>

VALUE hw_mNet, hw_cNetFTP, hw_cNetFTPList;
typedef struct ftpparse ftp_t;

/*
  Give me the struct behind the object.
  C guts, C guts run!
*/
ftp_t* cguts(VALUE self) {
  ftp_t* fp;
  Data_Get_Struct(self, ftp_t, fp);
  return fp;
}

/*
  The filename. In symlinked files this sometimes includes the destination. 
*/
VALUE name(VALUE self) {
  return rb_str_new2(cguts(self)->name);
}

/*
  The length of the filename in bytes.
*/
VALUE namelen(VALUE self) {
  return INT2FIX(cguts(self)->namelen);
}

/*
  CWD will be worth a shot as it's most likely a directory. It might also be a
  symlink if flagtryretr is also 1.
*/
VALUE flagtrycwd(VALUE self) {
  return INT2FIX(cguts(self)->flagtrycwd);
}

/*

*/
VALUE flagtryretr(VALUE self) {
  return INT2FIX(cguts(self)->flagtryretr);
}

VALUE sizetype(VALUE self) {
  return INT2FIX(cguts(self)->sizetype);
}

VALUE size(VALUE self) {
  return INT2FIX(cguts(self)->name);
}

VALUE mtimetype(VALUE self) {
  return INT2FIX(cguts(self)->mtimetype);
}

/* TODO time_t mtime */

/*
  Marks stuff in self for GC.
*/
void nfl_mark(ftp_t* self) {
  // Nothing yet.
}

/*
  Free up allocated struct memory.
*/
void nfl_free(ftp_t* self) {
  free(self);
}

/*
  Allocate and wrap a new ftpparse struct in Ruby goodness.
*/
VALUE nfl_allocate(VALUE klass) {
  ftp_t* fp = ALLOC(ftp_t);
  return Data_Wrap_Struct(klass, nfl_mark, nfl_free, fp);
}

/*
  The constructor.
*/
VALUE nfl_initialize(VALUE self, VALUE line) {
  char* cline = StringValuePtr(line); // TODO: Should line be anything that'll respond to #to_s ?
  int len     = RSTRING(line)->len;

  if (ftpparse(cguts(self), cline, len) != 1) {
    rb_raise(rb_eRuntimeError, "Unhandled LIST '%s'", cline);
  }

  return self;
}

/*
  Defines the extensions interface for Net::FTP::List.
*/
void Init_netftplist() {
  hw_mNet    = rb_define_module("Net");
  hw_cNetFTP = rb_define_class_under(hw_mNet, "FTP", rb_cObject);

  // This class.
  hw_cNetFTPList = rb_define_class_under(hw_cNetFTP, "List", rb_cObject);
  rb_define_alloc_func(hw_cNetFTPList, nfl_allocate);
  rb_define_method(hw_cNetFTPList, "initialize", nfl_initialize, 1);

  // An almost faithful readonly mirror of the struct interface. The id stuff
  // is missing because it's specific to Dan's FTP server according to the
  // Python guy.
  rb_define_method(hw_cNetFTPList, "name", name, 0);
  rb_define_method(hw_cNetFTPList, "namelen", namelen, 0);
  rb_define_method(hw_cNetFTPList, "flagtrycwd", flagtrycwd, 0);
  rb_define_method(hw_cNetFTPList, "flagtryretr", flagtryretr, 0);
  rb_define_method(hw_cNetFTPList, "sizetype", sizetype, 0);
  rb_define_method(hw_cNetFTPList, "size", size, 0);
  rb_define_method(hw_cNetFTPList, "mtimetype", mtimetype, 0);
}
