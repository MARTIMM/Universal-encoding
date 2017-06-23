use v6;

#------------------------------------------------------------------------------
use UEncoding;
use UEncoding::Engine;

#------------------------------------------------------------------------------
class xt::CString {

  #----------------------------------------------------------------------------
  method encode ( Str $value, --> List ) {

    die X::UEncoding.new(
      :message('encode, cstring, undefined string')
    ) unless ? $value;

    die X::UEncoding.new(
      :message('encode, cstring, Forbidden 0x00 sequence')
    ) if $value ~~ /\x00/;

    (|$value.encode(), 0x00).List;
  }

  #----------------------------------------------------------------------------
  method decode ( Buf $b, $from, $to ) {

  }
}
