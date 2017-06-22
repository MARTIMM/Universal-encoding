use v6;

#------------------------------------------------------------------------------
unit package UEncoding:auth<github:MARTIMM>;
use UEncoding;
use UEncoding::Engine;

#------------------------------------------------------------------------------
role ED {

  #----------------------------------------------------------------------------
  method buf ( --> Buf ) {

    my UEncoding::Engine $e .= instance;
    $e.buf;
  }

  #----------------------------------------------------------------------------
  method store-value( List $encoded-value, Bool :$init = False ) {

    my UEncoding::Engine $e .= instance;
    $e.init if $init;
    $e.store-value($encoded-value);
  }

  #----------------------------------------------------------------------------
  method encode ( $value ) { ... }
  method decode ( Buf $b, $from, $to ) { ... }
}
