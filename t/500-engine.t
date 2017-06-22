use v6;
use lib '.';
use Test;

use UEncoding;
use UEncoding::Engine;

#------------------------------------------------------------------------------
subtest 'engine tests', {

  my Map $pmap .= new: ( :CSTRING( <STRING Z8>));

  my UEncoding::Engine $e .= instance.init;
  isa-ok $e, UEncoding::Engine;

  $e.encode( '1234', (<CSTRING>,), $pmap);
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
    ), 'encode using pattern ok';

  $e.encode( '1234', (<CSTRING>,), $pmap);
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
      0x31, 0x32, 0x33, 0x34, 0x00
    ), 'added string encode ok';

  $e.init;
  is-deeply $e.buf, Buf.new(), 'Buf initialized';
  $e.encode( '1234', (<CString>,));
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
    ), 'encode using class UEncoding::Types::CString ok';

  $e.init;
  is-deeply $e.buf, Buf.new, 'Buf initialized';
  $e.encode( '1234', (<xt::CString>,));
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
    ), 'encode using class xt::CString ok';
}

#------------------------------------------------------------------------------
done-testing;
