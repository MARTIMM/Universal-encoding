use v6;
use Test;

use UEncoding;
use UEncoding::Types::CString;

#------------------------------------------------------------------------------
my UEncoding::Types::CString $c;

#------------------------------------------------------------------------------
subtest 'cstring', {

  $c .= new;
  $c.encode( '1234', :init);
  is-deeply $c.buf, Buf.new( 0x31, 0x32, 0x33, 0x34, 0x00), 'encode cstring ok';

  $c.encode( '1234');
  is-deeply $c.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
      0x31, 0x32, 0x33, 0x34, 0x00
    ), 'add encoded cstring ok';
}

#------------------------------------------------------------------------------
subtest 'encode int', {

  my UEncoding::Engine $e .= new;

  my Int $i = 1234;
  my Str $name = 'my-int';
}

#------------------------------------------------------------------------------
done-testing;
