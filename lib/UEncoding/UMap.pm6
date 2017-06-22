use v6;

#------------------------------------------------------------------------------
unit package UEncoding:auth<github:MARTIMM>;
use UEncoding;

#------------------------------------------------------------------------------
class UMap {

  #----------------------------------------------------------------------------
  method add-map-item (

  ) {

  }

  #----------------------------------------------------------------------------
  method set-encoding-profile ( *%profile ) {

    # Check recognized keys
    for %profile.keys -> $k {
      if $k !~~ any(|@UEncoding::mapControlFieldNames) {
        die X::UEncoding.new(:message("Unrecognized field name: $k"));
      }
    }


  }
}
