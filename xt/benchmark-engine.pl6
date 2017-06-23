#!/usr/bin/env perl6

use v6;
use Bench;

use UEncoding;
use UEncoding::Engine;



my UEncoding::Engine $e1 .= new;

my UEncoding::Engine $e2 .= new;

my UEncoding::Engine $e3 .= new;
$e3.user-procedure: {
  :c1(-> $value { ( |$value.encode(), 0x00).List; }),
};

my UEncoding::Engine $e4 .= new;
my Map $m4 .= new: ( :CSTRING( <STRING Z8>));

my UEncoding::Engine $e5 .= new;



my Bench $b .= new;
$b.cmpthese( 5000, {

    mapping => {
      $e1.encode( '0123456789', (<STRING Z8>));
    },

    sub-mapping => {
      $e4.encode( '0123456789', (<CSTRING>), $m4);
    },

    class => {
      $e2.encode( '0123456789', (<CString>));
    },

    user-pattern => {
      $e3.encode( '0123456789', (<c1>));
    },
  }
);

say "Buffer lengths: $e1.buf.elems(), $e2.buf.elems(), $e3.buf.elems()",
    ", $e4.buf.elems()";
