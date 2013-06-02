package List::Objects::WithUtils::Role::Array;
use strictures 1;

use Role::Tiny;

use List::Util ();
use List::MoreUtils ();
use List::UtilsBy ();

use Scalar::Util 'blessed';

use namespace::clean;

sub new {
  bless [ @_[1 .. $#_] ], $_[0] 
}

sub copy {
  bless [ @{ $_[0] } ], blessed($_[0])
}

sub count { CORE::scalar @{ $_[0] } }
{ no warnings 'once'; *scalar = *count; }

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
  blessed($_[0])->new(
    @{$_[0]}[ @_[1 .. $#_] ]
  )
}

sub splice {
  blessed($_[0])->new(
    CORE::splice @{ $_[0] }, $_[1], $_[2], @_[3 .. $#_]
  )
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
    while (my @nxt = $itr->()) { $_[2]->(@nxt) }
  } else { 
    return $itr
  }
}

sub items_after {
  blessed($_[0])->new(
    &List::MoreUtils::after( $_[1], @{ $_[0] } )
  )
}

sub items_after_incl {
  blessed($_[0])->new(
    &List::MoreUtils::after_incl( $_[1], @{ $_[0] } )
  )
}

sub items_before {
  blessed($_[0])->new(
    &List::MoreUtils::before( $_[1], @{ $_[0] } )
  )
}

sub items_before_incl {
  blessed($_[0])->new(
    &List::MoreUtils::before_incl( $_[1], @{ $_[0] } )
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

sub mesh {
  blessed($_[0])->new(
    &List::MoreUtils::mesh( @_ )
  )
#  my $max = -1;
#  for my $item (@_) {
#    $max = $#$item if $max < $#$item
#  }
#  blessed($_[0])->new(
#    map {;
#      my $idx = $_; map $_->[$idx], @_
#    } 0 .. $max
#  )
}


1;

=pod

=head1 NAME

List::Objects::WithUtils::Role::Array - Array manipulation methods

=head1 SYNOPSIS

  ## Via List::Objects::WithUtils::Array ->
  use List::Objects::WithUtils 'array';

  my $array = array(qw/ a b c /);

  $array->push(qw/ d e f /);

  my @upper = $array->map(sub { uc $_[0] })->all;

  if ( $array->has_any(sub { $_ eq 'a' }) ) {
    ...
  }

  ## As a Role ->
  use Role::Tiny::With;
  with 'List::Objects::WithUtils::Role::Array';

=head1 DESCRIPTION

A L<Role::Tiny> role defining methods for creating and manipulating ARRAY-type
objects.

L<List::Objects::WithUtils::Array> consumes this role (along with
L<List::Objects::WithUtils::Role::WithJunctions>) to provide B<array()> object
methods.

=head2 Basic Array Methods

=head3 new

Constructs a new ARRAY-type object.

=head3 copy

Creates a shallow clone of the current object.

=head3 clear

Clears the array entirely.

=head3 count

Returns the number of elements in the array.

=head3 scalar

Same as calling L</count>; returns the number of elements in the array.

=head3 is_empty

Returns boolean true if the array is empty.

=head3 all

Returns all elements in the array as a plain list.

=head3 get

Returns the array element corresponding to a specified index.

=head3 set

  $array->set( $index, $value );

Takes an array element and a new value to set.

Returns the array object.

=head3 pop

Pops the last element off the array and returns it.

=head3 push

Pushes elements to the end of the array.

Returns the array object.

=head3 shift

Shifts the first element off the beginning of the array and returns it.

=head3 unshift

Adds elements to the beginning of the array.

Returns the array object.

=head3 delete

Splices a given index out of the array.

=head3 insert

  $array->insert( $position, $value );

Inserts a value at a given position.

=head3 join

  my $str = $array->join(' ');

Joins the array's elements and returns the joined string.

Defaults to ',' if no delimiter is specified.

=head3 mesh

  my $meshed = array(qw/ a b c /)->mesh(
    array( 1, 2, 3 )
  );
  #  [ 'a', 1, 'b', 2, 'c', 3 ]

Takes array references or objects and returns a new array object consisting of
one element from each array, in turn, until all arrays have been traversed
fully.

=head3 natatime

  my $iter = array( 1 .. 7 )->natatime(3);
  $iter->();  ##  ( 1, 2, 3 )
  $iter->();  ##  ( 4, 5, 6 )
  $iter->();  ##  ( 7 )

  array( 1 .. 7 )->natatime(3, sub { my @vals = @_; ... });

Returns an iterator that, when called, produces a list containing the next
'n' items.

If given a coderef as a second argument, it will be called against each
bundled group.

=head3 reverse

Returns a new array object consisting of the reversed list of elements.

=head3 shuffle

  my $shuffled = $array->shuffle;

Shuffles the original list and returns a new array object.

=head3 sliced

  my $slice = $array->sliced(1, 3, 5);

Returns a new array object consisting of the elements retrived 
from the specified indexes.

=head3 splice

  ## 2-arg splice (remove elements):
  my $spliced = $array->splice(0, 2)
  ## 3-arg splice (replace):
  $array->splice(0, 1, 'abc');

Performs a C<splice()> on the current list and returns a new array object
consisting of the items returned from the splice.

The existing array is modified in-place.

=head3 uniq

  my $unique = $array->uniq;

Returns a new array object containing only unique elements from the original
array.

=head2 Methods that take subs with params

=head3 map

  my $lowercased = $array->map(sub { lc $_[0] });

Evaluates a given subroutine for each element of the array, and returns a new
array object. C<$_[0]> is the element being operated upon.

=head3 grep

  my $matched = $array->grep(sub { $_[0] =~ /foo/ });

Returns a new array object consisting of the list of elements for which the
given subroutine evaluated to true. C<$_[0]> is the element being operated
upon.

=head3 sort

  my $sorted = $array->sort(sub { $_[0] cmp $_[1] });

Returns a new array object consisting of the list sorted by the given
subroutine. C<$_[0]> and C<$_[1]> are equivalent to C<$a> and C<$b> in a
normal sort() call.

The existing array is not modified.)

=head3 reduce

  my $sum = array(1,2,3)->reduce(sub { $_[0] + $_[1] });

Reduces the array by calling the given subroutine for each element of the
list. See L<List::Util/"reduce">.

=head2 Methods that take subs with topicalizer

=head3 first

  my $arr = array( qw/ ab bc bd de / );
  my $first = $arr->first(sub { $_ =~ /^b/ });  ## 'bc'

Returns the first element of the list for which the given sub evaluates to
true. C<$_> is set to each element, in turn, until a match is found (or we run
out of possibles).

=head3 firstidx

Like L</first>, but return the index of the first successful match.

=head3 has_any

  if ( $array->has_any(sub { $_ eq 'foo' }) ) {
    ...
  }

If passed no arguments, returns the same thing as L</count>.

If passed a sub, returns boolean true if the sub is true for any element
of the array; see L<List::MoreUtils/"any">.

C<$_> is set to the element being operated upon.

=head3 items_after

  my $after = array( 1 .. 10 )->items_after(sub { $_ == 5 });
  ## $after contains [ 6, 7, 8, 9, 10 ]

Returns a new array object consisting of the elements of the original list
that occur after the first position for which the given sub evaluates to true.

=head3 items_after_incl

Like L</items_after>, but include the item that evaluated to true.

=head3 items_before

The opposite of L</items_after>.

=head3 items_before_incl

The opposite of L</items_after_incl>.

=head3 sort_by

  my $array = array(
    { id => 'a' },
    { id => 'c' },
    { id => 'b' },
  );
  my $sorted = $array->sort_by(sub { $_->{id} });

Returns a new array object consisting of the list of elements sorted via a
stringy comparison using the given sub. 
See L<List::UtilsBy>.

=head3 nsort_by

Like L</sort_by>, but using numerical comparison.

=head3 uniq_by

  my $array = array(
    { id => 'a' },
    { id => 'a' },
    { id => 'b' },
  );
  my $unique = $array->uniq_by(sub { $_->{id} });

Returns a new array object consisting of the list of elements for which the
given sub returns unique values.

=head1 SEE ALSO

L<List::Objects::WithUtils>

L<List::Objects::WithUtils::Array>

L<List::Objects::WithUtils::Role::WithJunctions>

L<Data::Perl>

L<List::Util>

L<List::MoreUtils>

L<List::UtilsBy>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Portions of this code are derived from L<Data::Perl> by Matthew Phillips
(CPAN: MATTP), haarg et al

Licensed under the same terms as Perl.

=cut

