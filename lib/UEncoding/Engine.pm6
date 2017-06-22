use v6;

#------------------------------------------------------------------------------
unit package UEncoding:auth<github:MARTIMM>;
use UEncoding;

#------------------------------------------------------------------------------
class Engine {

  has Buf $.buf;
  has Int $!index;

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
  method encode ( Any $value, List $pattern, Map $pattern-map ) {

    for |$pattern -> $p {
note "Patt: $p, ", $p.WHAT;
#      my UEncoding::PatternCode $pattern-code = ::("UEncoding::$p");
      my $pattern-code = try { ::("UEncoding::$p") };
note "Patt code: $pattern-code, ", $pattern-code.WHAT;

      given $pattern-code {
        when UEncoding::STRING {
          self.store-value: (|$value.encode);
        }

        when UEncoding::Z8 {
          self.store-value: (0x00,);
        }

        default {
          if ? $pattern-map{$p} {
            self.encode( $value, $pattern-map{$p}, $pattern-map);
          }

          else {
            die X::UEncoding.new(:message("No such pattern code: $p"));
          }
        }
      }
    }
  }
}
