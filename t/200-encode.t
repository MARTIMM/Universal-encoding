use v6;
use lib '.';
use Test;

use UEncoding;
use UEncoding::Engine;
use UEncoding::Types::CString;
use xt::CString;

#------------------------------------------------------------------------------
my UEncoding::Engine $e .= new;

#------------------------------------------------------------------------------
subtest 'cstring', {
  my UEncoding::Types::CString $c .= new;

  # $e.init;
  $c.encode( '1234', :engine($e));
  is-deeply $e.buf,
    Buf.new( 0x31, 0x32, 0x33, 0x34, 0x00),
    'encode cstring ok';

  $c.encode( '1234', :engine($e));
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
      0x31, 0x32, 0x33, 0x34, 0x00
    ), 'add encoded cstring ok';

  # Test 'user defined' module for test 500
  my xt::CString $x .= new;
  $e.init;
  $x.encode( '1234', :engine($e));
  $x.encode( '1234', :engine($e));
  is-deeply $e.buf, Buf.new(
      0x31, 0x32, 0x33, 0x34, 0x00,
      0x31, 0x32, 0x33, 0x34, 0x00
    ), "add encoded cstring done by 'user defined' object ok";
}

#------------------------------------------------------------------------------
subtest 'encode int', {

  my UEncoding::Engine $e .= new;

  my Int $i = 1234;
  my Str $name = 'my-int';
}

#------------------------------------------------------------------------------
done-testing;
