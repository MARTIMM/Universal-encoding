use v6;

#------------------------------------------------------------------------------
unit package UEncoding:auth<github:MARTIMM>;
use UEncoding;

#------------------------------------------------------------------------------
class Engine {

  has Buf $.buf;
  has Int $!index;
  has Hash $!mapped-procedures;

  #----------------------------------------------------------------------------
  my UEncoding::Engine $instance;
  method instance ( ) {

    $instance .= new.init unless ? $instance;
    $instance;
  }

  #----------------------------------------------------------------------------
  method init ( ) {

    $!buf .= new;
    $!index = 0;
    $!mapped-procedures = {
      UEncoding::STRING => -> $value {
        self.store-value: (|$value.encode);
      },

      UEncoding::Z8 => {
        self.store-value: (0x00,);
      }

      UEncoding::Z16 => {
        self.store-value: (0x00 xx 2);
      }

      UEncoding::Z32 => {
        self.store-value: (0x00 xx 4);
      }

      UEncoding::Z64 => {
        self.store-value: (0x00 xx 8);
      }
    };

    self;
  }

  #----------------------------------------------------------------------------
  method store-value ( List $encoded-value ) {

    die X::UEncoding.new(
      :message("No value to store")
    ) unless ? $encoded-value;

    $!index += $encoded-value.elems;
    $!buf.push: |$encoded-value;
  }

  #----------------------------------------------------------------------------
  method encode ( Any $value, List $pattern, Map $pattern-map = Map.new() ) {

    for |$pattern -> $p {
      my $pattern-code = try { ::("UEncoding::$p") } // $p;
note "Patt code: $pattern-code, ", $pattern-code.WHAT;

      if $pattern-code ~~ UEncoding::PatternCode {

        $!mapped-procedures{$pattern-code}($value);
      }

      else {
        # test for map name in pattern map
        if ? $pattern-map{$p} {
          self.encode( $value, $pattern-map{$p}, $pattern-map);
        }

        else {
          # try provided class first
          my $class-name = "UEncoding::Types::$p";
          my $pck = try { require ::($class-name); }
#note "$class-name -> ", $pck.^name;

          # maybe then user provided class
          if $pck.^name eq 'Any' {
            $class-name = $p;
            $pck = try { require ::($class-name); }
#note "$class-name -> ", $pck.^name;
          }

          # when we get an object, check for the encode method
          if $pck.^name ne 'Any' {
            my $obj = $pck.new;

            unless $obj.^can('encode') {
              die X::UEncoding.new(
                :message("Class $class-name did not provide method encode")
              );
            }

            $obj.encode($value);
          }

          else {
            die X::UEncoding.new(:message("No such pattern code or object: $p"));
          }
        }
      }
    }
  }
}
