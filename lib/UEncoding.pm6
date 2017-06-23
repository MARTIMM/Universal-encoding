use v6;

class X::UEncoding is Exception {

  has Str $.message;

  submethod BUILD ( :$!message ) {}
}

#------------------------------------------------------------------------------
package UEncoding:auth<github:MARTIMM> {

  enum PatternCode <<
   :STRING(1) Z8 Z16 Z32 Z64
  >>;
}
