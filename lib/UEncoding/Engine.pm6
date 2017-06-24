use v6;

#------------------------------------------------------------------------------
unit package UEncoding:auth<github:MARTIMM>;
use UEncoding;

#------------------------------------------------------------------------------
class Engine {

  has Buf $.buf;
  has Int $!index;
  has Hash $!mapped-procedures;
  has Hash $!user-procedures;

  #----------------------------------------------------------------------------
  submethod BUILD ( ) {

    self.init;
  }

  #----------------------------------------------------------------------------
  method init ( ) {

    $!buf .= new;
    $!index = 0;

    $!mapped-procedures = {
      UEncoding::STRING => -> $value {
        List.new(|$value.encode);
      },

      UEncoding::Z8 => {
      (0x00).List;
      },

      UEncoding::Z16 => {
        (0x00 xx 2).List;
      },

      UEncoding::Z32 => {
        (0x00 xx 4).List;
      },

      UEncoding::Z64 => {
        (0x00 xx 8).List;
      },
    };

    $!user-procedures = {};
  }

  #----------------------------------------------------------------------------
  multi method user-procedure ( Str:D $pattern-code, Code:D $code ) {

    if $!user-procedures{$pattern-code}:exists {
      die X::UEncoding.new(:message("Procedure for $pattern-code exists"));
    }

    else {
      $!user-procedures{$pattern-code} = $code;
    }
  }

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  multi method user-procedure ( Hash $procedures ) {

    for $procedures.kv -> Str $pattern-code, Code $code {

      if $!user-procedures{$pattern-code}:exists {
        die X::UEncoding.new(:message("Procedure for $pattern-code exists"));
      }

      else {
        $!user-procedures{$pattern-code} = $code;
      }
    }
  }

  #----------------------------------------------------------------------------
  method store-value ( List $encoded-value ) {

    die X::UEncoding.new(:message("No value to store")) unless ? $encoded-value;

#note "EV: ", $encoded-value.WHAT, ', ', $encoded-value.perl;

    $!index += $encoded-value.elems;
    $!buf.push: |$encoded-value;
#note "Buf: ", $!buf;
  }

  #----------------------------------------------------------------------------
#TODO concurrency

  method encode ( $vals, $patts, Map $pattern-map = Map.new() ) {

    my Array $values = $vals ~~ Array ?? $vals !! [$vals];
    my List $pattern = $patts ~~ List ?? $patts !! List.new($patts);

    for @$pattern -> $p {

      # check if $p is an enum value of UEncoding::PatternCode
      my $pattern-code = try { ::("UEncoding::$p") } // $p;

#note "Patt code: $pattern-code, ", $pattern-code.WHAT, ', ',
#      $!mapped-procedures{$pattern-code}, ', ',
#      $!user-procedures{$pattern-code};

      # If it is a package defined name, its code must be provided
      if $pattern-code ~~ UEncoding::PatternCode {
#note "package code from $pattern-code";
        self!check-and-call( $!mapped-procedures{$pattern-code}, $values);
      }

      # check if user has code defined under this pattern code
      elsif ? $!user-procedures{$pattern-code} {
#note "user code from $p: ", $!user-procedures{$pattern-code};
        self!check-and-call( $!user-procedures{$pattern-code}, $values);
      }

      # test for map name in pattern map
      elsif ? $pattern-map{$pattern-code} {
#note "user pattern map from $pattern-code: ", $pattern-map{$p};
        self.encode( $values, $pattern-map{$pattern-code}, $pattern-map);
      }

      # check for package or user provided classes
      else {
        # try provided class first
        my $class-name = "UEncoding::Types::$pattern-code";
        my $pck = try { require ::($class-name); }
#note "package class $class-name";

        # maybe then user provided class
        if $pck.^name eq 'Any' {
          $class-name = $pattern-code;
          $pck = try { require ::($class-name); }
#note "user class $class-name";
        }

        # when we get an object, check for the encode method
        if $pck.^name ne 'Any' {
          my $obj = $pck.new;

          unless $obj.^can('encode') {
            die X::UEncoding.new(
              :message("Class $class-name did not provide method encode")
            );
          }

          self.store-value: $obj.encode(self!get-value($values));
        }

        else {
          die X::UEncoding.new(:message("No such pattern code or object: $p"));
        }
      }
    }
  }

  #----------------------------------------------------------------------------
  method !check-and-call ( Code:D $s, $values ) {

    if $s.signature.arity {
      self.store-value: $s(self!get-value($values));
    }

    else {
      self.store-value: $s();
    }
  }

  #----------------------------------------------------------------------------
  method !get-value ( Array:D $values --> Any ) {

    die X::UEncoding.new(:message('No more values')) unless $values.elems;
    shift $values;
  }
}
