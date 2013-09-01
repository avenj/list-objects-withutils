package List::Objects::WithUtils::Role::Array;
use strictures 1;

use Carp ();

use List::Util ();
use List::MoreUtils ();
use List::UtilsBy ();

use Scalar::Util ();

=pod

=for Pod::Coverage ARRAY_TYPE blessed_or_pkg

=begin comment

Regarding blessed_or_pkg():
This is some nonsense to support autoboxing; if we aren't blessed, we're
autoboxed, in which case we appear to have no choice but to cheap out and
return the basic array type:

=end comment

=cut

sub ARRAY_TYPE () { 'List::Objects::WithUtils::Array' }
sub _blessed_or_pkg {
  my $pkg;
  ($pkg = Scalar::Util::blessed $_[0]) ?
   $pkg : Module::Runtime::use_module(ARRAY_TYPE)
}


sub __flatten_all {
  ref $_[0] eq 'ARRAY' 
  || Scalar::Util::blessed($_[0]) 
     # 5.8 doesn't have ->DOES()
     && $_[0]->can('does')
     && $_[0]->does('List::Objects::WithUtils::Role::Array') ?
     map {; __flatten_all($_) } @{ $_[0] }
  : $_[0]
}

sub __flatten {
  my $depth = shift;
  CORE::map {
    ref eq 'ARRAY' 
    || Scalar::Util::blessed($_)
       && $_->can('does')
       && $_->does('List::Objects::WithUtils::Role::Array') ?
      $depth > 0 ? __flatten( $depth - 1, @$_ ) : $_
      : $_
  } @_
}


use Role::Tiny;

=pod

=for Pod::Coverage TO_JSON

=cut

sub TO_JSON { [ @{ $_[0] } ] }

sub _try_coerce {
  my (undef, $type, @vals) = @_;
  Carp::confess "Expected a Type::Tiny type but got $type"
    unless Scalar::Util::blessed $type;
  CORE::map {;
    my $coerced;
    $type->check($_) ? $_
    : $type->assert_valid( ($coerced = $type->coerce($_)) ) ? $coerced
    : Carp::confess "I should be unreachable!"
  } @vals
}


sub new {
  bless [ @_[1 .. $#_] ], $_[0] 
}

sub copy {
  my ($self) = @_;
  bless [ @$self ], $self->_blessed_or_pkg
}

sub validated {
  my ($self, $type) = @_;
  bless [ map {; $self->_try_coerce($type, $_) } @$self ], $self->_blessed_or_pkg
}

sub all { @{ $_[0] } }

sub count { CORE::scalar @{ $_[0] } }

{ no warnings 'once'; *scalar = *count; *export = *all; }

sub is_empty { CORE::scalar @{ $_[0] } ? 0 : 1 }

sub get { $_[0]->[ $_[1] ] }
sub set { $_[0]->[ $_[1] ] = $_[2] ; $_[0] }

sub random { $_[0]->[ rand @{ $_[0] } ] }

sub head {
  my ($self) = @_;
  wantarray ?
    ( 
      $self->[0], 
      $self->_blessed_or_pkg->new( @{ $self }[ 1 .. $#$self ] ) 
    )
    : $self->[0]
}

sub tail {
  my ($self) = @_;
  wantarray ?
    (
      $self->[-1],
      $self->_blessed_or_pkg->new( @{ $self }[ 0 .. ($#$self - 1) ] )
    )
    : $self->[-1]
}

sub pop  { CORE::pop @{ $_[0] } }
sub push { 
  CORE::push @{ $_[0] }, @_[1 .. $#_]; 
  $_[0] 
}

sub shift   { CORE::shift @{ $_[0] } }
sub unshift { 
  CORE::unshift @{ $_[0] }, @_[1 .. $#_]; 
  $_[0] 
}

sub clear  { @{ $_[0] } = (); $_[0] }

sub delete { 
  scalar( 
    CORE::splice @{ $_[0] }, $_[1], 1
  ) 
}

sub insert { 
  CORE::splice @{ $_[0] }, $_[1], 0, $_[2];
  $_[0] 
}

sub join { 
  CORE::join( 
    ( defined $_[1] ? $_[1] : ',' ), 
    @{ $_[0] } 
  ) 
}

sub map {
  my ($self, $sub) = @_;
  $self->_blessed_or_pkg->new(
    CORE::map {; $sub->($_) } @$self
  )
}

sub mapval {
  my ($self, $sub) = @_;
  my @copy = @$self;
  $self->_blessed_or_pkg->new(
    CORE::map {; $sub->($_); $_ } @copy
  )
}

sub grep {
  my ($self, $sub) = @_;
  $self->blessed_or_pkg->new(
    CORE::grep {; $sub->($_) } @$self
  )
}

sub sort {
  my ($self, $sub) = @_;
  my $pkg = $self->_blessed_or_pkg;
  if (defined $sub) {
    return $pkg->new(
      CORE::sort {; $sub->($a, $b) } @$self
    )
  }
  return $self->_blessed_or_pkg->new( CORE::sort @$self )
}

sub reverse {
  my ($self) = @_;
  $self->_blessed_or_pkg->new(
    CORE::reverse @$self
  )
}

sub sliced {
  my ($self) = @_;
  $self->_blessed_or_pkg->new(
    @{ $self }[ @_[1 .. $#_] ]
  )
}

sub splice {
  my ($self) = @_;
  $self->_blessed_or_pkg->new(
    CORE::splice @$self, $_[1], $_[2], @_[3 .. $#_]
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

sub mesh {
  for (@_) {
    Carp::confess("Expected ARRAY or compatible obj, got $_")
      unless (Scalar::Util::reftype($_) || '') eq 'ARRAY'
  }
  $_[0]->_blessed_or_pkg->new(
    &List::MoreUtils::mesh( @_ )
  )
# In case upstream ever changes, here's a pure-perl impl:
#  my $max_idx = -1;
#  for my $item (@_) {
#    $max_idx = $#$item if $max_idx < $#$item
#  }
#  blessed_or_pkg($_[0])->new(
#    map {;
#      my $idx = $_; map {; $_->[$idx] } @_
#    } 0 .. $max_idx
#  )
}

sub natatime {
  my $itr = List::MoreUtils::natatime($_[1], @{ $_[0] } );
  if ($_[2]) {
    while (my @nxt = $itr->()) { $_[2]->(@nxt) }
  } else { 
    return $itr
  }
}

sub part {
  my ($self, $code) = @_;
  my @parts;
  CORE::push @{ $parts[ $code->($_) ] }, $_ for @$self;
  my $cls = blessed_or_pkg($self);
  $cls->new(
    map {; $cls->new(defined $_ ? @$_ : () ) } @parts
  )
}

sub bisect {
  my ($self, $code) = @_;
  my @parts = ( [], [] );
  CORE::push @{ $parts[ $code->($_) ? 0 : 1 ] }, $_ for @$self;
  my $cls = blessed_or_pkg($self);
  $cls->new(
    map {; $cls->new(@$_) } @parts
  )
}


sub tuples {
  # FIXME add optional Type::Tiny typecheck?
  my ($self, $size, $type) = @_;
  $size = 2 unless defined $size;
  Carp::confess "Expected a positive integer size but got $size"
    if $size < 0;
  my $itr = List::MoreUtils::natatime($size, @$self);
  my $new = blessed_or_pkg($self)->new;
  while (my @nxt = $itr->()) {
    if (defined $type) {
      @nxt = CORE::map {; $self->_try_coerce($type, $_) } @nxt
    }
    $new->push( [ (@nxt == 2 ? @nxt : (@nxt, undef) ) ] )
  }
  $new
}

sub reduce {
  List::Util::reduce { $_[1]->($a, $b) } @{ $_[0] }
}

sub items_after {
  blessed_or_pkg($_[0])->new(
    &List::MoreUtils::after( $_[1], @{ $_[0] } )
  )
}

sub items_after_incl {
  blessed_or_pkg($_[0])->new(
    &List::MoreUtils::after_incl( $_[1], @{ $_[0] } )
  )
}

sub items_before {
  blessed_or_pkg($_[0])->new(
    &List::MoreUtils::before( $_[1], @{ $_[0] } )
  )
}

sub items_before_incl {
  blessed_or_pkg($_[0])->new(
    &List::MoreUtils::before_incl( $_[1], @{ $_[0] } )
  )
}

sub shuffle {
  blessed_or_pkg($_[0])->new(
    List::Util::shuffle( @{ $_[0] } )
  )
}

sub uniq {
  blessed_or_pkg($_[0])->new(
    List::MoreUtils::uniq( @{ $_[0] } )
  )
}

sub sort_by {
  blessed_or_pkg($_[0])->new(
    &List::UtilsBy::sort_by( $_[1], @{ $_[0] } )
  )
}

sub nsort_by {
  blessed_or_pkg($_[0])->new(
    &List::UtilsBy::nsort_by( $_[1], @{ $_[0] } )
  )
}

sub uniq_by {
  blessed_or_pkg($_[0])->new(
    &List::UtilsBy::uniq_by( $_[1], @{ $_[0] } )
  )
}

sub flatten_all {
  CORE::map {;  __flatten_all($_)  } @{ $_[0] }
}

sub flatten {
  __flatten( 
    ( defined $_[1] ? $_[1] : 0 ),
    @{ $_[0] } 
  )
}

print
  qq[<Schroedingers_hat> My sleeping pattern is cryptographically secure.\n]
unless caller;
1;

=pod

=head1 NAME

List::Objects::WithUtils::Role::Array - Array manipulation methods

=head1 SYNOPSIS

  ## Via List::Objects::WithUtils::Array ->
  use List::Objects::WithUtils 'array';

  my $array = array(qw/ a b c /);

  $array->push(qw/ d e f /);

  my @upper = $array->map(sub { uc })->all;

  if ( $array->has_any(sub { $_ eq 'a' }) ) {
    ...
  }

  my $sum = array(1 .. 10)->reduce(sub { $_[0] + $_[1] });

  # See below for full list of methods

  ## As a Role ->
  use Role::Tiny::With;
  with 'List::Objects::WithUtils::Role::Array';

=head1 DESCRIPTION

A L<Role::Tiny> role defining methods for creating and manipulating ARRAY-type
objects.

L<List::Objects::WithUtils::Array> consumes this role (along with
L<List::Objects::WithUtils::Role::WithJunctions>) to provide B<array()> object
methods.

In addition to the methods documented below, these objects provide a
C<TO_JSON> method exporting a plain ARRAY-type reference for convenience when
feeding L<JSON::Tiny> or similar.

=head2 Basic array methods

=head3 new

Constructs a new ARRAY-type object.

=head3 copy

Creates a shallow clone of the current object.

=head3 count

Returns the number of elements in the array.

=head3 is_empty

Returns boolean true if the array is empty.

=head3 scalar

See L</count>.

=head2 Methods that manipulate the list

=head3 clear

Clears the array entirely.

=head3 delete

Splices a given index out of the array.

=head3 insert

  $array->insert( $position, $value );

Inserts a value at a given position.

=head3 pop

Pops the last element off the array and returns it.

=head3 push

Pushes elements to the end of the array.

Returns the array object.

=head3 set

  $array->set( $index, $value );

Takes an array element and a new value to set.

Returns the array object.

=head3 shift

Shifts the first element off the beginning of the array and returns it.

=head3 unshift

Adds elements to the beginning of the array.

Returns the array object.

=head3 splice

  # 2-arg splice (remove elements):
  my $spliced = $array->splice(0, 2)
  # 3-arg splice (replace):
  $array->splice(0, 1, 'abc');

Performs a C<splice()> on the current list and returns a new array object
consisting of the items returned from the splice.

The existing array is modified in-place.

=head3 validated

  use Types::Standard -all;
  my $valid = array(qw/foo bar baz/)->validated(Str);

Accepts a L<Type::Tiny> type, against which each element of the current array
will be checked before being added to the new array. 

If the element fails the type check but can be coerced, the coerced value will
be added to the new array.

Dies with a stack trace if the value fails type checks and can't be coerced.

See: L<Types::Standard>, L</List::Objects::Types>

=head2 Methods that retrieve items

=head3 all

Returns all elements in the array as a plain list.

=head3 bisect

  my ($true, $false) = array( 1 .. 10 )
    ->bisect(sub { $_[0] >= 5 })
    ->all;
  my @bigger  = $true->all;   # ( 5 .. 10 )
  my @smaller = $false->all;  # ( 1 .. 4 )

Like L</part>, but creates an array-type object containing two
partitions; the first contains all items for which the subroutine evaluates to
true, the second contains the remaining items.

=head3 export

Same as L</all>; included for consistency with hash-type objects.

=head3 flatten

Flatten array objects to plain lists, possibly recursively.

C<flatten> without arguments is the same as L</all>:

  my @flat = array( 1, 2, [ 3, 4 ] )->flatten;
  #  @flat = ( 1, 2, [ 3, 4 ] );

If a depth is specified, sub-arrays are recursively flattened until the
specified depth is reached: 

  my @flat = array( 1, 2, [ 3, 4 ] )->flatten(1);
  #  @flat = ( 1, 2, 3, 4 );

  my @flat = array( 1, 2, [ 3, 4, [ 5, 6 ] ] )->flatten(1);
  #  @flat = ( 1, 2, 3, 4, [ 5, 6 ] );

This works with both ARRAY-type references and array objects:

  my @flat = array( 1, 2, [ 3, 4, array( 5, 6 ) ] )->flatten(2);
  #  @flat = ( 1, 2, 3, 4, 5, 6 );

(Specifically, consumers of this role are flattened; other ARRAY-type objects
are left alone.)

See L</flatten_all> for flattening to an unlimited depth.

=head3 flatten_all

Returns a plain list consisting of all sub-arrays recursively
flattened. Also see L</flatten>.

=head3 get

Returns the array element corresponding to a specified index.

=head3 head

  my ($first, $rest) = $array->head;

In list context, returns the first element of the list, and a new array-type
object containing the remaining list. The original object's list is untouched.

In scalar context, returns just the first element of the array:

  my $first = $array->head;

=head3 tail

Similar to L</head>, but returns either the last element and a new array-type
object containing the remaining list (in list context), or just the last
element of the list (in scalar context).

=head3 join

  my $str = $array->join(' ');

Joins the array's elements and returns the joined string.

Defaults to ',' if no delimiter is specified.

=head3 mesh

  my $meshed = array(qw/ a b c /)->mesh(
    array( 1 .. 3 )
  );
  $meshed->all;  # 'a', 1, 'b', 2, 'c', 3

Takes array references or objects and returns a new array object consisting of
one element from each array, in turn, until all arrays have been traversed
fully.

You can mix and match references and objects freely:

  my $meshed = array(qw/ a b c /)->mesh(
    array( 1 .. 3 ),
    [ qw/ foo bar baz / ],
  );

=head3 part

  my $parts = array( 1 .. 8 )->part(sub { $i++ % 2 });
  # Returns array objects:
  $parts->get(0)->all;  # 1, 3, 5, 7
  $parts->get(1)->all;  # 2, 4, 6, 8

Takes a subroutine that indicates into which partition each value should be
placed.

Returns an array-type object containing partitions represented as array-type
objects, as seen above.

Skipped partitions are empty array objects:

  my $parts = array(qw/ foo bar /)->part(sub { 1 });
  $parts->get(0)->is_empty;  # true
  $parts->get(1)->is_empty;  # false

The subroutine is passed the value we are operating on:

  array(qw/foo bar baz 1 2 3/)
    ->part(sub { $_[0] =~ /^[0-9]+$/ ? 0 : 1 })
    ->get(1)
    ->all;   # 'foo', 'bar', 'baz'

=head3 random

Returns a random element from the array.

=head3 reverse

Returns a new array object consisting of the reversed list of elements.

=head3 shuffle

  my $shuffled = $array->shuffle;

Returns a new array object containing the shuffled list.

=head3 sliced

  my $slice = $array->sliced(1, 3, 5);

Returns a new array object consisting of the elements retrived 
from the specified indexes.

=head3 tuples

  my $tuples = array(1 .. 7)->tuples(2);
  # Returns:
  #  array(
  #    [ 1, 2 ], 
  #    [ 3, 4 ],
  #    [ 5, 6 ],
  #    [ 7, undef ],
  #  )

Simple sugar for L</natatime>; returns a new array object consisting of tuples
(unblessed ARRAY references) of the specified size (defaults to 2).

C<tuples> accepts L<Type::Tiny> types as an optional second parameter; if
specified, items in tuples are checked against the type and a coercion is
attempted if the initial type-check fails; a stack-trace is thrown if a value
in a tuple cannot be made to validate:

  use Types::Standard -all;
  my $tuples = array(1 .. 7)->tuples(2, Int);

See: L<Types::Standard>, L</List::Objects::Types>

=head2 Methods that find items

=head3 grep

  my $matched = $array->grep(sub { $_[0] =~ /foo/ });

Returns a new array object consisting of the list of elements for which the
given subroutine evaluated to true. C<$_[0]> is the element being operated
on; you can also use the topicalizer C<$_>.

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

=head2 Methods that iterate the list

=head3 map

  my $lowercased = $array->map(sub { lc });
  # Same as:
  my $lowercased = $array->map(sub { lc $_[0] });

Evaluates a given subroutine for each element of the array, and returns a new
array object. C<$_[0]> is the element being operated on; you can also use
the topicalizer C<$_>.

Also see L</mapval>.

=head3 mapval

  my $orig = array(1, 2, 3);
  my $incr = $orig->mapval(sub { ++$_ });

  $incr->all;  # (2, 3, 4)
  $orig->all;  # Still untouched

An alternative to L</map>. C<$_> is a copy, rather than an alias to the
current element, and the result is retrieved from the altered C<$_> rather
than the return value of the block.

This feature is borrowed from L<Data::Munge> by Lukas Mai (CPAN: MAUKE).

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

=head3 reduce

  my $sum = array(1,2,3)->reduce(sub { $_[0] + $_[1] });

Reduces the array by calling the given subroutine for each element of the
list. See L<List::Util/"reduce">.

=head2 Methods that sort the list

=head3 sort

  my $sorted = $array->sort(sub { $_[0] cmp $_[1] });

Returns a new array object consisting of the list sorted by the given
subroutine. C<$_[0]> and C<$_[1]> are equivalent to C<$a> and C<$b> in a
normal sort() call.

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

=head3 uniq

  my $unique = $array->uniq;

Returns a new array object containing only unique elements from the original
array.

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

