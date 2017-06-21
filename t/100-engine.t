use v6;
use Test;

use Encoding;
use Encoding::Engine;

#------------------------------------------------------------------------------
subtest 'engine tests', {

  my Encoding::Engine $e .= new;
  isa-ok $e, Encoding::Engine;
}

#------------------------------------------------------------------------------
done-testing;
