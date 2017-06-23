use v6;
use lib '.';
use Test;

use UEncoding;
use UEncoding::Engine;

my UEncoding::Engine $e .= new;

#------------------------------------------------------------------------------
isa-ok $e, UEncoding::Engine;
subtest 'engine using mapping patterns', {

  my Map $pmap .= new: ( :CSTRING( <STRING Z8>));

  $e.encode( '1234', (<CSTRING>), $pmap);
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
    ), 'encode using pattern';

  $e.encode( '1234', (<CSTRING>), $pmap);
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
      0x31, 0x32, 0x33, 0x34, 0x00
    ), 'added string encode using pattern';
}

#------------------------------------------------------------------------------
subtest 'engine using modules', {

  $e.init;
  is-deeply $e.buf, Buf.new(), 'Buf initialized';

  $e.encode( '1234', (<CString>));
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
    ), 'encode using class UEncoding::Types::CString';

  my Map $pmap .= new: ( :X( <xt::CString>));

  $e.init;
  $e.encode( '1234', (<X>,), $pmap);
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
    ), 'encode using class xt::CString in sub pattern';
}

#------------------------------------------------------------------------------
subtest 'engine using added user procedures', {

  $e.init;
  $e.user-procedure(
    'X1',
    -> $value { List.new( 0xff, |$value.encode(), 0xff); }
  );

  $e.encode( '1234', <X1>);
  is-deeply $e.buf, Buf.new(
      0xFF, 0x31, 0x32, 0x33, 0x34, 0xFF,
    ), 'encode using inserted user procedure';

  throws-like {
      $e.user-procedure(
        'X1',
        -> $value {#`{{no code needed for this test, insertion should fail}} }
      )
    },
    X::UEncoding,
    :message('Procedure for X1 exists');
}

#------------------------------------------------------------------------------
subtest 'engine using mix off all', {

  $e.init;

  my Map $pmap .= new: (
    :A<B>, :B<mp3>, :X<xt::CString>, :Y<Z64 STRING>, :Z<mp2 mp1 mp2>
  );
  $e.user-procedure: {
    :mp1(-> $value { List.new( 0xff, $value +& 0xff, 0xff); }),
    :mp2({ List.new( 0x10, 0x20, 0x30); }),
    :mp3({ List.new( |'abc'.encode); }),
  };

  $e.encode( [ '23', '1234', 0x28], <X Y Z A>, $pmap);
  is-deeply $e.buf, Buf.new(
      0x32, 0x33, 0x00,
      0x00 xx 8,
      0x31, 0x32, 0x33, 0x34,
      0x10, 0x20, 0x30,
      0xff, 0x28, 0xff,
      0x10, 0x20, 0x30,
      0x61, 0x62, 0x63
    ), 'Mixed tests';

  #note $e.buf;
}

#------------------------------------------------------------------------------
done-testing;
