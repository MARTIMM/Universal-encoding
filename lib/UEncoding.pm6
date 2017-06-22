use v6;

class X::UEncoding is Exception {

  has Str $.message;

  submethod BUILD ( :$!message ) {}
}

#------------------------------------------------------------------------------
package UEncoding:auth<github:MARTIMM> {

  enum PatternCode <<
   :SUB-PATTERN(0x8000) :PATTERN(0x7fff)

   :STRING(0x0001) Z8 Z16 Z32 Z64
  >>;



  our @mapControlFieldNames = <
    add-doc-size doc-size-type add-doc-trail doc-trail-bytes
    include-field-name field-name-type
  >;

}
