package List::Objects::WithUtils::Role::Immutable;
use strictures 1;
use Carp 'confess';

use Scalar::Util 'blessed', 'reftype';

use Role::Tiny;

sub ___unimp {
  confess 'Method not implemented'
}
{ no warnings 'once';
  *clear = *___unimp;
  *set   = *___unimp;
  *pop   = *___unimp;
  *push  = *___unimp;
  *shift = *___unimp;
  *unshift = *___unimp;
  *delete  = *___unimp;
  *insert  = *___unimp;
  *splice  = *___unimp;
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



1;
