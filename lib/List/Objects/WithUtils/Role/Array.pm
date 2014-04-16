package List::Objects::WithUtils::Role::Array;

use strictures 1;

use Carp            ();
use List::Util      ();
use Module::Runtime ();
use Scalar::Util    ();

# This (and relevant tests) can disappear if UtilsBy gains XS:
our $UsingUtilsByXS = 0;
{ no warnings 'once';
  if (eval {; require List::UtilsBy::XS; 1 } && !$@) {
    $UsingUtilsByXS = 1;
    *__sort_by  = *List::UtilsBy::XS::sort_by;
    *__nsort_by = *List::UtilsBy::XS::nsort_by;
    *__uniq_by  = *List::UtilsBy::XS::uniq_by;
  } else {
    require List::UtilsBy;
    *__sort_by  = *List::UtilsBy::sort_by;
    *__nsort_by = *List::UtilsBy::nsort_by;
    *__uniq_by  = *List::UtilsBy::uniq_by;
  }
}

use constant USING_LIST_MOREUTILS => !! eval {;
  require List::MoreUtils;
  (List::MoreUtils->VERSION || '') =~ /^0.3/
};

=pod

=for Pod::Coverage ARRAY_TYPE blessed_or_pkg

=begin comment

Regarding blessed_or_pkg():
This is some nonsense to support autoboxing; if we aren't blessed, we're
autoboxed, in which case we appear to have no choice but to cheap out and
return the basic array type.

This should only be called to get your hands on ->new().

->new() methods should be able to operate on a blessed invocant.

=end comment

=cut

sub ARRAY_TYPE () { 'List::Objects::WithUtils::Array' }

sub blessed_or_pkg {
  Scalar::Util::blessed($_[0]) ? 
    $_[0] : Module::Runtime::use_module(ARRAY_TYPE)
}


sub __flatten_all {
  # __flatten optimized for max depth:
  ref $_[0] eq 'ARRAY' || Scalar::Util::blessed($_[0]) 
      # 5.8 doesn't have ->DOES()
      && $_[0]->can('does') 
      && $_[0]->does('List::Objects::WithUtils::Role::Array') ?
        map {; __flatten_all($_) } @{ $_[0] }
    : $_[0]
}

sub __flatten {
  my $depth = shift;
  CORE::map {
    ref eq 'ARRAY' || Scalar::Util::blessed($_)
        && $_->can('does')
        && $_->does('List::Objects::WithUtils::Role::Array') ?
          $depth > 0 ? __flatten( $depth - 1, @$_ ) : $_
      : $_
  } @_
}


use Role::Tiny;


sub inflated_type { 'List::Objects::WithUtils::Hash' }

sub is_mutable { 1 }
sub is_immutable { ! $_[0]->is_mutable }

# subclass-mungable (keep me under the Role::Tiny import):
sub _try_coerce {
  my (undef, $type, @vals) = @_;
    Carp::confess "Expected a Type::Tiny type but got $type"
      unless Scalar::Util::blessed $type;

  CORE::map {;
    my $coerced;
    $type->check($_) ? $_
    : $type->assert_valid( 
        $type->has_coercion ? ($coerced = $type->coerce($_)) : $_
      ) ? $coerced
      : Carp::confess "I should be unreachable!"
  } @vals
}

=pod

=for Pod::Coverage TO_JSON damn type

=cut

sub type {
  # array() has an empty ->type
}

sub new { bless [ @_[1 .. $#_ ] ], Scalar::Util::blessed($_[0]) || $_[0] }

sub copy { blessed_or_pkg($_[0])->new(@{ $_[0] }) }

sub inflate {
  my ($self) = @_;
  my $pkg = blessed_or_pkg($self);
  Module::Runtime::require_module( $pkg->inflated_type );
  $pkg->inflated_type->new(@$self)
}

sub unbless { [ @{ $_[0] } ] }
{ no warnings 'once'; *TO_JSON = *unbless; *damn = *unbless; }

sub validated {
  my ($self, $type) = @_;
  # Autoboxed?
  $self = blessed_or_pkg($self)->new(@$self)
    unless Scalar::Util::blessed $self;
  blessed_or_pkg($_[0])->new(
    CORE::map {; $self->_try_coerce($type, $_) } @$self
  )
}

sub all { @{ $_[0] } }
{ no warnings 'once'; *export = *all; *elements  = *all; }

sub count { CORE::scalar @{ $_[0] } }
{ no warnings 'once'; *scalar = *count;  }

sub end { $#{ $_[0] } }

sub is_empty { ! @{ $_[0] } }

sub get { $_[0]->[ $_[1] ] }
sub set { $_[0]->[ $_[1] ] = $_[2] ; $_[0] }

sub random { $_[0]->[ rand @{ $_[0] } ] }

sub kv {
  my ($self) = @_;
  blessed_or_pkg($self)->new(
    map {; [ $_ => $self->[$_] ] } 0 .. $#$self
  )
}

sub head {
  wantarray ?
    ( 
      $_[0]->[0], 
      blessed_or_pkg($_[0])->new( @{ $_[0] }[ 1 .. $#{$_[0]} ] ) 
    )
    : $_[0]->[0]
}

sub tail {
  wantarray ?
    (
      $_[0]->[-1],
      blessed_or_pkg($_[0])->new( @{ $_[0] }[ 0 .. ($#{$_[0]} - 1) ] )
    )
    : $_[0]->[-1]
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

sub delete { scalar CORE::splice @{ $_[0] }, $_[1], 1 }

sub delete_when {
  my ($self, $sub) = @_;
  my @removed;
  my $i = @$self;
  while ($i--) {
    local *_ = \$self->[$i];
    CORE::push @removed, CORE::splice @$self, $i, 1 if $sub->($_);
  }
  blessed_or_pkg($_[0])->new(@removed)
}

sub insert { 
  $#{$_[0]} = ($_[1]-1) if $_[1] > $#{$_[0]};
  CORE::splice @{ $_[0] }, $_[1], 0, $_[2];
  $_[0] 
}

sub intersection {
  my %seen;
  blessed_or_pkg($_[0])->new(
    # Well. Probably not the most efficient approach . . .
    CORE::grep {; ++$seen{$_} > $#_ } 
      CORE::map {; 
        my %s = (); CORE::grep {; not $s{$_}++ } @$_
      } @_
  )
}

sub diff {
  my %seen;
  my @vals = CORE::map {; 
    my %s = (); CORE::grep {; not $s{$_}++ } @$_
  } @_;
  $seen{$_}++ for @vals;
  my %inner;
  blessed_or_pkg($_[0])->new(
    CORE::grep {; $seen{$_} != @_ }
      CORE::grep {; not $inner{$_}++ } @vals
  )
}

sub join { 
  CORE::join( 
    ( defined $_[1] ? $_[1] : ',' ), 
    @{ $_[0] } 
  ) 
}

sub map {
  blessed_or_pkg($_[0])->new(
    CORE::map {; $_[1]->($_) } @{ $_[0] }
  )
}

sub mapval {
  my ($self, $sub) = @_;
  my @copy = @$self;
  blessed_or_pkg($self)->new(
    CORE::map {; $sub->($_); $_ } @copy
  )
}

sub visit {
  $_[1]->($_) for @{ $_[0] };
  $_[0]
}

sub grep {
  blessed_or_pkg($_[0])->new(
    CORE::grep {; $_[1]->($_) } @{ $_[0] }
  )
}


=pod

=for Pod::Coverage indices

=cut

{ no warnings 'once'; *indices = *indexes; }
sub indexes {
  blessed_or_pkg($_[0])->new(
    USING_LIST_MOREUTILS ? &List::MoreUtils::indexes( $_[1], @{ $_[0] } )
      : grep {; local *_ = \$_[0]->[$_]; $_[1]->() } 0 .. $#{ $_[0] }
  )
}

sub sort {
  if (defined $_[1]) {
    return blessed_or_pkg($_[0])->new(
      CORE::sort {; $_[1]->($a, $b) } @{ $_[0] }
    )
  }
  return blessed_or_pkg($_[0])->new( CORE::sort @{ $_[0] } )
}

sub reverse {
  blessed_or_pkg($_[0])->new( CORE::reverse @{ $_[0] } )
}

=pod

=for Pod::Coverage slice

=cut

{ no warnings 'once'; *slice = *sliced }
sub sliced {
  my @safe = @{ $_[0] };
  blessed_or_pkg($_[0])->new( @safe[ @_[1 .. $#_] ] )
}

sub splice {
  blessed_or_pkg($_[0])->new(
    @_ == 2 ? CORE::splice( @{ $_[0] }, $_[1] )
      : CORE::splice( @{ $_[0] }, $_[1], $_[2], @_[3 .. $#_] )
  )
}

sub has_any {
  defined $_[1] ? !! &List::Util::first( $_[1], @{ $_[0] } )
    : !! @{ $_[0] }
}

=pod

=for Pod::Coverage first

=cut

{ no warnings 'once'; *first = *first_where }
sub first_where { &List::Util::first( $_[1], @{ $_[0] } ) }

sub last_where {
  my ($self, $cb) = @_;

  return &List::MoreUtils::lastval($cb, @$self) if USING_LIST_MOREUTILS;

  my $i = @$self;
  while ($i--) {
    local *_ = \$self->[$i];
    my $ret = $cb->();
    $self->[$i] = $_;
    return $_ if $ret;
  }
  undef
}

{ no warnings 'once';
  *first_index = *firstidx;
  *last_index  = *lastidx;
}
sub firstidx { 
  my ($self, $cb) = @_;

  return &List::MoreUtils::firstidx($cb, @$self) if USING_LIST_MOREUTILS;

  for my $i (0 .. $#$self) {
    local *_ = \$self->[$i];
    return $i if $cb->();
  }
  -1
}

sub lastidx {
  my ($self, $cb) = @_;

  return &List::MoreUtils::lastidx($cb, @$self) if USING_LIST_MOREUTILS;

  for my $i (CORE::reverse 0 .. $#$self) {
    local *_ = \$self->[$i];
    return $i if $cb->(); 
  }
  -1
}

sub mesh {
  my $max_idx = -1;
  for (@_) { $max_idx = $#$_ if $max_idx < $#$_ }
  blessed_or_pkg($_[0])->new(
    CORE::map {;
      my $idx = $_; map {; $_->[$idx] } @_
    } 0 .. $max_idx
  )
}

sub natatime {
  my @list  = @{ $_[0] };
  my $count = $_[1];
  my $itr = sub { CORE::splice @list, 0, $count };
  if ($_[2]) {
    while (my @nxt = $itr->()) { $_[2]->(@nxt) }
  } else { 
    return $itr
  }
}

sub rotator {
  my @list = @{ $_[0] };
  my $pos = 0;
  sub {
    my $val = $list[$pos++];
    $pos = 0 if $pos == @list;
    $val
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
  my ($self, $size, $type) = @_;
  $size = 2 unless defined $size;
  if (defined $type) {
    # Autoboxed? Need to be blessed if we're to _try_coerce
    $self = blessed_or_pkg($self)->new(@$self)
      unless Scalar::Util::blessed $self;
  }
  Carp::confess "Expected a positive integer size but got $size"
    if $size < 1;
  my $itr = do {
    my @copy = @$self;
    sub { CORE::splice @copy, 0, $size }
  };
  my @res;
  while (my @nxt = $itr->()) {
    if (defined $type) {
      @nxt = CORE::map {; $self->_try_coerce($type, $_) }
        @nxt[0 .. ($size-1)]
    }
    CORE::push @res, [ @nxt ];
  }
  blessed_or_pkg($self)->new(@res)
}

sub reduce {
  List::Util::reduce { $_[1]->($a, $b) } @{ $_[0] }
}

sub rotate {
  my ($self, %params) = @_;
  if ($params{left} && $params{right}) {
    Carp::confess "Cannot rotate in both directions!"
  } elsif ($params{right}) {
    return blessed_or_pkg($self)->new(
      @$self ? ($self->[-1], @{ $self }[0 .. ($#$self - 1)]) : ()
    )
  } else {
    return blessed_or_pkg($self)->new(
      @$self ? (@{ $self }[1 .. $#$self], $self->[0]) : ()
    )
  }
}

sub rotate_in_place { $_[0] = $_[0]->rotate(@_[1 .. $#_]) }

sub items_after {
  my ($started, $lag);
  blessed_or_pkg($_[0])->new(
    USING_LIST_MOREUTILS ? &List::MoreUtils::after($_[1], @{ $_[0] })
      : CORE::grep $started ||= do {
          my $x = $lag; $lag = $_[1]->(); $x
      }, @{ $_[0] }
  )
}

sub items_after_incl {
  my $started;
  blessed_or_pkg($_[0])->new(
    USING_LIST_MOREUTILS ? &List::MoreUtils::after_incl($_[1], @{ $_[0] })
      : CORE::grep $started ||= $_[1]->(), @{ $_[0] }
  )
}

sub items_before {
  my $more = 1;
  blessed_or_pkg($_[0])->new(
    USING_LIST_MOREUTILS ? &List::MoreUtils::before($_[1], @{ $_[0] })
      : CORE::grep $more &&= !$_[1]->(), @{ $_[0] }
  )
}

sub items_before_incl {
  my $more = 1; my $lag = 1;
  blessed_or_pkg($_[0])->new(
    USING_LIST_MOREUTILS ? &List::MoreUtils::before_incl($_[1], @{ $_[0] })
      : CORE::grep $more &&= do {
          my $x = $lag; $lag = !$_[1]->(); $x
      }, @{ $_[0] }
  )
}

sub shuffle {
  blessed_or_pkg($_[0])->new(
    List::Util::shuffle( @{ $_[0] } )
  )
}

sub uniq {
  my %s;
  blessed_or_pkg($_[0])->new(
    USING_LIST_MOREUTILS ? &List::MoreUtils::uniq(@{ $_[0] })
      : grep {; not $s{$_}++ } @{ $_[0] }
  )
}

sub sort_by {
  blessed_or_pkg($_[0])->new(
    __sort_by( $_[1], @{ $_[0] } )
  )
}

sub nsort_by {
  blessed_or_pkg($_[0])->new(
    __nsort_by( $_[1], @{ $_[0] } )
  )
}

sub uniq_by {
  blessed_or_pkg($_[0])->new(
    __uniq_by( $_[1], @{ $_[0] } )
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
L<List::Objects::WithUtils::Role::Array::WithJunctions>) to provide B<array()> object
methods.

In addition to the methods documented below, these objects provide a
C<TO_JSON> method exporting a plain ARRAY-type reference for convenience when
feeding L<JSON::Tiny> or similar.

=head2 Basic array methods

=head3 new

Constructs a new ARRAY-type object.

=head3 copy

Returns a shallow clone of the current object.

=head3 count

Returns the number of elements in the array.

=head3 end

Returns the last index of the array (or -1 if the array is empty).

=head3 is_empty

Returns boolean true if the array is empty.

=head3 is_mutable

Returns boolean true if the hash is mutable; immutable subclasses can override
to provide a negative value.

=head3 is_immutable

The opposite of L</is_mutable>. (Subclasses do not need to override so long as
L</is_mutable> returns a correct value.)

=head3 inflate

  my $hash = $array->inflate;
  # Same as:
  # my $hash = hash( $array->all )

Inflates an array-type object to a hash-type object.

Returns an L</inflated_type> object; by default this is a
L<List::Objects::WithUtils::Hash>.

Throws an exception if the array contains an odd number of elements.

=head3 inflated_type

The class name that objects are blessed into when calling L</inflate>;
subclasses can override to provide their own hash-type objects.

Defaults to L<List::Objects::WithUtils::Hash>.

=head3 scalar

See L</count>.

=head3 unbless

Returns a plain C</ARRAY> reference (shallow clone).

=head2 Methods that manipulate the list

=head3 clear

Delete all elements from the array.

Returns the newly-emptied array object.

=head3 delete

Splices a given index out of the array.

Returns the removed value.

=head3 delete_when

  $array->delete_when( sub { $_ eq 'foo' } );

Splices all items out of the array for which the given subroutine evaluates to
true.

Returns a new array object containing the deleted values (possibly none).

=head3 insert

  $array->insert( $position, $value );

Inserts a value at a given position, moving the rest of the array rightwards.

The array will be "backfilled" (with undefs) if $position is past the end of
the array.

Returns the array object.

=head3 pop

Pops the last element off the array and returns it.

=head3 push

Pushes elements to the end of the array.

Returns the array object.

=head3 rotate_in_place

  array(1 .. 3)->rotate_in_place;             # 2, 3, 1
  array(1 .. 3)->rotate_in_place(right => 1); # 3, 1, 2

Rotates the array in-place. A direction can be given.

Also see L</rotate>, L</rotator>.

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

  # 1- or 2-arg splice (remove elements):
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
will be checked before being added to a new array. Returns the new array.

If the element fails the type check but can be coerced, the coerced value will
be added to the new array.

Dies with a stack trace if the value fails type checks and can't be coerced.

(You probably want an B<array_of> object from
L<List::Objects::WithUtils::Array::Typed> instead.)

See: L<Types::Standard>, L<List::Objects::Types>

=head2 Methods that retrieve items

=head3 all

Returns all elements in the array as a plain list.

=head3 bisect

  my ($true, $false) = array( 1 .. 10 )
    ->bisect(sub { $_ >= 5 })
    ->all;
  my @bigger  = $true->all;   # ( 5 .. 10 )
  my @smaller = $false->all;  # ( 1 .. 4 )

Like L</part>, but creates an array-type object containing two
partitions; the first contains all items for which the subroutine evaluates to
true, the second contains the remaining items.

=head3 elements

Same as L</all>; included for consistency with similar array-type object
classes.

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

=head3 kv

Returns an array-type object containing key/value pairs as (unblessed) ARRAYs;
this is much like L<List::Objects::WithUtils::Role::Hash/"kv">, except the
array index is the key.

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

The subroutine is passed the value we are operating on, or you can use the
topicalizer C<$_>:

  array(qw/foo bar baz 1 2 3/)
    ->part(sub { m/^[0-9]+$/ ? 0 : 1 })
    ->get(1)
    ->all;   # 'foo', 'bar', 'baz'

=head3 random

Returns a random element from the array.

=head3 reverse

Returns a new array object consisting of the reversed list of elements.

=head3 rotate

  my $leftwards  = $array->rotate;
  my $rightwards = $array->rotate(right => 1);

Returns a new array object containing the rotated list.

Also see L</rotate_in_place>, L</rotator>.

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
  #    [ 7 ],
  #  )

Simple sugar for L</natatime>; returns a new array object consisting of tuples
(unblessed ARRAY references) of the specified size (defaults to 2).

C<tuples> accepts L<Type::Tiny> types as an optional second parameter; if
specified, items in tuples are checked against the type and a coercion is
attempted if the initial type-check fails:

  use Types::Standard -all;
  my $tuples = array(1 .. 7)->tuples(2 => Int);

A stack-trace is thrown if a value in a tuple cannot be made to validate.

See: L<Types::Standard>, L<List::Objects::Types>

=head2 Methods that find items

=head3 grep

  my $matched = $array->grep(sub { /foo/ });

Returns a new array object consisting of the list of elements for which the
given subroutine evaluates to true. C<$_[0]> is the element being operated
on; you can also use the topicalizer C<$_>.

=head3 indexes

  my $matched = $array->indexes(sub { /foo/ });

Like L</grep>, but returns a new array object consisting of the list of
B<indexes> for which the given subroutine evaluates to true.

=head3 first_where

  my $arr = array( qw/ ab bc bd de / );
  my $first = $arr->first_where(sub { /^b/ });  ## 'bc'

Returns the first element of the list for which the given sub evaluates to
true. C<$_> is set to each element, in turn, until a match is found (or we run
out of possibles).

=head3 first_index

Like L</first_where>, but return the index of the first successful match.

=head3 firstidx

An alias for L</first_index>.

=head3 last_where

Like L</first_where>, but returns the B<last> successful match.

=head3 last_index

Like L</first_index>, but returns the index of the B<last> successful match.

=head3 lastidx

An alias for L</last_index>.

=head3 has_any

  if ( $array->has_any(sub { $_ eq 'foo' }) ) {
    ...
  }

If passed no arguments, returns boolean true if the array has any elements.

If passed a sub, returns boolean true if the sub is true for any element
of the array.

C<$_> is set to the element being operated upon.

=head3 intersection

  my $first  = array(qw/ a b c /);
  my $second = array(qw/ b c d /);
  my $intersection = $first->intersection($second);

Returns a new array object containing the list of values common between all
given array-type objects (including the invocant).

The new array object is not sorted in any predictable order.

(It may be worth noting that an intermediate hash is used; objects that
stringify to the same value will be taken to be the same.)

=head3 diff

  my $first  = array(qw/ a b c d /);
  my $second = array(qw/ b c x /);
  my @diff = $first->diff($second)->sort->all;  # (a, d, x)

The opposite of L</intersection>; returns a new array object containing the
list of values that are not common between all given array-type objects
(including the invocant).

The same constraints as L</intersection> apply.

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

=head3 rotator

  my $rot = array(qw/cat sheep mouse/);
  $rot->();  ## 'cat'
  $rot->();  ## 'sheep'
  $rot->();  ## 'mouse'
  $rot->();  ## 'cat'

Returns an iterator that, when called, produces the next element in the array;
when there are no elements left, the iterator returns to the start of the
array.

See also L</rotate>, L</rotate_in_place>.

=head3 reduce

  my $sum = array(1,2,3)->reduce(sub { $_[0] + $_[1] });

Reduces the array by calling the given subroutine for each element of the
list. See L<List::Util/"reduce">.

=head3 visit

  $arr->visit(sub { warn "array contains: $_" });

Executes the given subroutine against each element sequentially; in practice
this is much like L</map>, except the return value is thrown away.

Returns the original array object.

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

Uses L<List::UtilsBy::XS> if available.

=head3 nsort_by

Like L</sort_by>, but using numerical comparison.

=head3 uniq

  my $unique = $array->uniq;

Returns a new array object containing only unique elements from the original
array.

(It may be worth noting that this takes place via an intermediate hash;
objects that stringify to the same value are not unique, even if they are
different objects. L</uniq_by> plus L<Scalar::Util/"refaddr"> may help you
there.)

=head3 uniq_by

  my $array = array(
    { id => 'a' },
    { id => 'a' },
    { id => 'b' },
  );
  my $unique = $array->uniq_by(sub { $_->{id} });

Returns a new array object consisting of the list of elements for which the
given sub returns unique values.

Uses L<List::UtilsBy::XS> if available; falls back to L<List::UtilsBy> if not.

=head1 SEE ALSO

L<List::Objects::WithUtils>

L<List::Objects::WithUtils::Array>

L<List::Objects::WithUtils::Array::Immutable>

L<List::Objects::WithUtils::Array::Typed>

L<List::Objects::WithUtils::Role::Array::WithJunctions>

L<Data::Perl>

L<List::Util>

L<List::UtilsBy>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Portions of this code are derived from L<Data::Perl> by Matthew Phillips
(CPAN: MATTP), haarg et al

Licensed under the same terms as Perl.

=cut

