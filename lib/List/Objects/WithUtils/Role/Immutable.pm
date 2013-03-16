package List::Objects::WithUtils::Role::Immutable;
use strictures 1;
use Carp 'confess';

use Role::Tiny;
use Scalar::Util 'blessed', 'reftype';

use namespace::clean;

sub new {
  bless [
    map {; 
      ( ref $_ && reftype($_) eq 'ARRAY' ) ? @$_ : $_ 
    } @_[1 .. $#_]
  ], $_[0]
}

sub head {
  if (wantarray) {
    return (
      $_[0]->[0], 
      blessed($_[0])->new( @{ $_[0] }[ 1 .. $#{$_[0]} ] )
    )
  }
  $_[0]->[0]
}

sub tail {
  if (wantarray) {
    return (
      $_[0]->[-1],
      blessed($_[0])->new( @{ $_[0] }[ 0 .. ($#{$_[0]} - 1) ] )
    )
  }
  $_[0]->[-1]
}

sub set  { confess "Not implemented" }
sub pop  { confess "Not implemented" }
sub push { confess "Not implemented" }
sub shift   { confess "Not implemented" }
sub unshift { confess "Not implemented" }
sub clear  { confess "Not implemented" }
sub delete { confess "Not implemented" }
sub insert { confess "Not implemented" }
sub splice { confess "Not implemented" }

1;
