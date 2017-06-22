use v6;
use Test;

use UEncoding;
use UEncoding::UMap;

#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
subtest 'profile', {

  my UEncoding::UMap $m .= new;
#$m.set-encoding-profile( :add-doc-size(True), :xyz(10));
  throws-like { $m.set-encoding-profile( :add-doc-size(True), :xyz(10)) },
    X::UEncoding,
    :message('Unrecognized field name: xyz');

  $m.set-encoding-profile(
    :add-doc-size, :doc-size-type(INT32),
    :add-doc-trail, :doc-trail-bytes(0x00),
    :include-field-name, :field-name-type(CSTRING),
  );

}

#------------------------------------------------------------------------------
done-testing;
