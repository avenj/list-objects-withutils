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
sub set { $_[0]->[ $_[1] ] = $_[2] ; $_[0] }

sub pop  { CORE::pop @{ $_[0] } }
sub push { CORE::push @{ $_[0] }, @_[1 .. $#_] ; $_[0] }

sub shift   { CORE::shift @{ $_[0] } }
sub unshift { CORE::unshift @{ $_[0] }, @_[1 .. $#_] ; $_[0] }

sub clear  { @{ $_[0] } = (); $_[0] }
sub delete { scalar( CORE::splice(@{ $_[0] }, $_[1], 1) ) }
sub insert { CORE::splice(@{ $_[0] }, $_[1], 0, $_[2]); $_[0] }

sub join { CORE::join( (defined $_[1] ? $_[1] : ','), @{ $_[0] } ) }

sub map {
  blessed($_[0])->new(
    CORE::map {; $_[1]->($_) } @{ $_[0] }
  )
}

sub grep {
  blessed($_[0])->new(
    CORE::grep {; $_[1]->($_) } @{ $_[0] }
  )
}

sub sort {
  my @sorted;
  if (defined $_[1]) {
    @sorted = CORE::sort {; $_[1]->($a, $b) } @{ $_[0] }
  } else {
    @sorted = CORE::sort @{ $_[0] }
  }
  blessed($_[0])->new(@sorted)
}

sub reverse {
  blessed($_[0])->new(
    CORE::reverse @{ $_[0] }
  )
}

sub sliced {
  my ($self, @pos) = @_;
  blessed($_[0])->new(
    @{$_[0]}[ @_[1 .. $#_] ]
  )
}

sub splice {
  my @tmp = @{ $_[0] };
  CORE::splice @tmp, $_[1], $_[2], @_[3 .. $#_];
  blessed($_[0])->new( @tmp )
}

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

=head2 new

Constructs a new ARRAY-type object.

=head2 copy

Creates a shallow clone of the current object.

=head2 clear

Clears the array entirely.

=head2 count

Returns the number of elements in the array.

=head2 scalar

The same as calling L</count>.

=head2 is_empty

Returns boolean true if the array is empty.

=head2 all

Returns all elements in the array as a plain list.

=head2 get

Returns the array element corresponding to a specified index.

=head2 set

  $array->set( $index, $value );

Takes an array element and a new value to set.

Returns the array object.

=head2 pop

Pops the last element off the array and returns it.

=head2 push

Pushes elements to the end of the array.

Returns the array object.

=head2 shift

Shifts the first element off the beginning of the array and returns it.

=head2 unshift

Adds elements to the beginning of the array.

Returns the array object.

=head2 delete

Splices a given index out of the array.

=head2 insert

  $array->insert( $position, $value );

Inserts a value at a given position.

=head2 join

  my $str = $array->join(' ');

Joins the array's elements and returns the joined string.

Defaults to ',' if no delimiter is specified.

=head2 map

  my $lowercased = $array->map(sub { lc $_[0] });

Evaluates a given subroutine for each element of the array, and returns a new
array object. C<$_[0]> is the element being operated upon.

=head2 grep

  my $matched = $array->grep(sub { $_[0] =~ /foo/ });

Returns a new array object consisting of the list of elements for which the
given subroutine evaluated to true. C<$_[0]> is the element being operated
upon.

=head2 sort

  my $sorted = $array->sort(sub { $_[0] cmp $_[1] });

Returns a new array object consisting of the list sorted by the given
subroutine. C<$_[0]> and C<$_[1]> are equivalent to C<$a> and C<$b> in a
normal sort() call.

=head2 reverse

Returns a new array object consisting of the reversed list of elements.

=head2 sliced

  my $slice = $array->sliced(1, 3, 5);

Returns a new array object consisting of the elements retrived 
from the specified indexes.

=head2 splice

  my $spliced = $array->splice(0, 1, 'abc');

Performs a C<splice()> on the current list and returns a new array object.
(The existing array is not modified.)

=head2 has_any

  if ( $array->has_any(sub { $_ eq 'foo' }) ) {
    ...
  }

If passed no arguments, returns the same thing as L</count>.

If passed a sub, returns boolean true if the sub is true for any element
of the array; see L<List::MoreUtils/"any">. C<$_> is set to the element being
operated upon.

=head1 SEE ALSO

L<List::Objects::WithUtils>

L<Data::Perl>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Portions of this code are derived from L<Data::Perl> by Matthew Phillips
(CPAN: MATTP)

Licensed under the same terms as Perl.

=cut

