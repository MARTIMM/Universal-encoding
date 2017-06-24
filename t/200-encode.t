use v6;
use lib '.';
use Test;

#use UEncoding;
use UEncoding::Types::CString;
use xt::CString;

#------------------------------------------------------------------------------
subtest 'cstring', {
  my UEncoding::Types::CString $c .= new;

  my List $b = $c.encode('1234');
  is-deeply Buf.new($b), Buf.new( 0x31, 0x32, 0x33, 0x34, 0x00),
            'encode cstring ok';

  # Test 'user defined' module for test 500
  my xt::CString $x .= new;
  $b = $x.encode('1234');
  is-deeply Buf.new($b), Buf.new( 0x31, 0x32, 0x33, 0x34, 0x00),
            "add encoded cstring done by 'user defined' object ok";
}

#------------------------------------------------------------------------------
subtest 'encode int', {

  my Int $i = 1234;
  my Str $name = 'my-int';
}

#------------------------------------------------------------------------------
done-testing;
