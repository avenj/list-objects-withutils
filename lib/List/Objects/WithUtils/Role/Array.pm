package List::Objects::WithUtils::Role::Array;
use strictures 1;

use Role::Tiny;

use List::Util ();
use List::MoreUtils ();
use List::UtilsBy ();

use Scalar::Util 'blessed';

sub new {
  bless [ @_[1 .. $#_] ], $_[0] 
}

sub copy {
  bless [ @{ $_[0] } ], blessed($_[0])
}

sub count { CORE::scalar @{ $_[0] } }
{ no warnings 'once';
  *scalar = *count;
}

sub is_empty { CORE::scalar @{ $_[0] } ? 0 : 1 }

sub all { @{ $_[0] } }
sub get { $_[0]->[ $_[1] ] }
sub set { $_[0]->[ $_[1] ] = $_[2] }

sub pop  { CORE::pop @{ $_[0] } }
sub push { CORE::push @{ $_[0] }, @_[1 .. $#_] }

sub shift   { CORE::shift @{ $_[0] } }
sub unshift { CORE::unshift @{ $_[0] }, @_[1 .. $#_] }

sub clear  { @{ $_[0] } = () }
sub delete { scalar( CORE::splice(@{ $_[0] }, $_[1], 1) ) }
sub insert { scalar( CORE::splice(@{ $_[0] }, $_[1], 0, $_[2]) ) }

sub join { CORE::join( (defined $_[1] ? $_[1] : ','), @{ $_[0] } ) }

sub has_any {
  unless (defined $_[1]) {
    return CORE::scalar @{ $_[0] }
  }

  &List::MoreUtils::any( $_[1], @{ $_[0] } )
}

sub first { 
  &List::Util::first( $_[1], @{ $_[0] } ) 
}

sub firstidx { 
  &List::MoreUtils::firstidx( $_[1], @{ $_[0] } )
}

sub reduce {
  List::Util::reduce { $_[1]->($a, $b) } @{ $_[0] }
}

sub natatime {
  my $itr = List::MoreUtils::natatime($_[1], @{ $_[0] } );
  if ($_[2]) {
    while (my @nxt = $itr->()) {
      $_[2]->(@nxt)
    }
  } else { 
    $itr 
  }
}

sub map {
  blessed($_[0])->new(
    CORE::map { $_[1]->($_) } @{ $_[0] }
  )
}

sub grep {
  blessed($_[0])->new(
    CORE::grep { $_[1]->($_) } @{ $_[0] }
  )
}

sub sort {
  blessed($_[0])->new(
    CORE::sort { $_[1]->($a, $b) } @{ $_[0] }
  )
}

sub reverse {
  blessed($_[0])->new(
    CORE::reverse @{ $_[0] }
  )
}

sub sliced {
  blessed($_[0])->new(
    $_[0]->[ @_[1 .. $#_] ]
  )
}

sub splice {
  blessed($_[0])->new(
    CORE::splice @{ $_[0] },
      $_[1], $_[2], @_[3 .. $#_]
  )
}

sub items_after {
  blessed($_[0])->new(
    &List::MoreUtils::after( $_[1], @{ $_[0] } )
  )
}

sub items_before {
  blessed($_[0])->new(
    &List::MoreUtils::before( $_[1], @{ $_[0] } )
  )
}

sub shuffle {
  blessed($_[0])->new(
    List::Util::shuffle( @{ $_[0] } )
  )
}

sub uniq {
  blessed($_[0])->new(
    List::MoreUtils::uniq( @{ $_[0] } )
  )
}

sub sort_by {
  blessed($_[0])->new(
    &List::UtilsBy::sort_by( $_[1], @{ $_[0] } )
  )
}

sub nsort_by {
  blessed($_[0])->new(
    &List::UtilsBy::nsort_by( $_[1], @{ $_[0] } )
  )
}

sub uniq_by {
  blessed($_[0])->new(
    &List::UtilsBy::uniq_by( $_[1], @{ $_[0] } )
  )
}

1;

=pod

=head1 NAME

List::Objects::WithUtils::Role::Array - Array manipulation methods

=head1 SYNOPSIS

  use List::Objects::WithUtils 'array';

  my $array = array(qw/ a b c /);

  $array->push(qw/ d e f /);

  my @upper = $array->map(sub { uc $_[0] })->all;

  ## ...etc...

=head1 DESCRIPTION

A L<Role::Tiny> role defining methods for creating and manipulating ARRAY-type
objects.

=head1 SEE ALSO

L<Data::Perl>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Portions of this code are derived from L<Data::Perl> by Matthew Phillips
(CPAN: MATTP)

Licensed under the same terms as Perl.

=cut

