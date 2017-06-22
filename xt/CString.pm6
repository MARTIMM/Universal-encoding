use v6;

#------------------------------------------------------------------------------
use UEncoding;
use UEncoding::Engine;
use UEncoding::ED;

#------------------------------------------------------------------------------
class xt::CString does UEncoding::ED {

  #----------------------------------------------------------------------------
  method encode ( Str $value, :$init = False ) {

    die X::UEncoding.new(
      :message('encode, cstring, undefined string')
    ) unless ? $value;

    die X::UEncoding.new(
      :message('encode, cstring, Forbidden 0x00 sequence')
    ) if $value ~~ /\x00/;

    my List $v = (|$value.encode(), 0x00);
    self.store-value( $v, :$init);
  }

  #----------------------------------------------------------------------------
  method decode ( Buf $b, $from, $to ) {

  }
}
