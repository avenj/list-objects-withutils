package List::Objects::WithUtils::Role::Hash;
use strictures 1;

use Module::Runtime ();
use Scalar::Util ();

=pod

=for Pod::Coverage HASH_TYPE blessed_or_pkg

=cut

sub HASH_TYPE () { 'List::Objects::WithUtils::Hash' }
sub blessed_or_pkg { 
  my $pkg;
  ($pkg = Scalar::Util::blessed $_[0]) ?
    $pkg : Module::Runtime::use_module(HASH_TYPE)
}

use Role::Tiny;

sub array_type       { 'List::Objects::WithUtils::Array' }
sub inflated_type    { 'List::Objects::WithUtils::Hash::Inflated' }
sub inflated_rw_type { 'List::Objects::WithUtils::Hash::Inflated::RW' }

=pod

=for Pod::Coverage TO_JSON type

=cut

sub TO_JSON { +{ %{ $_[0] } } }

sub type { }

sub new {
  Module::Runtime::require_module( $_[0]->array_type );
  bless +{ @_[1 .. $#_] }, $_[0]
}

sub clear { %{ $_[0] } = (); $_[0] }

sub copy {
  bless +{ %{ $_[0] } }, blessed_or_pkg($_[0])
}

sub inflate {
  my ($self, %params) = @_;
  my $type = $params{rw} ? 'inflated_rw_type' : 'inflated_type';
  my $pkg = blessed_or_pkg($self);
  Module::Runtime::require_module( $pkg->$type );
  $pkg->$type->new( %$self )
}

sub defined { CORE::defined $_[0]->{ $_[1] } }
sub exists  { CORE::exists  $_[0]->{ $_[1] } }

sub is_empty { keys %{ $_[0] } ? 0 : 1 }

sub get {
  if (@_ > 2) {
    return blessed_or_pkg($_[0])->array_type->new(
      @{ $_[0] }{ @_[1 .. $#_] }
    )
  }
  $_[0]->{ $_[1] }
}

sub sliced {
  blessed_or_pkg($_[0])->new(
    map {;
      exists $_[0]->{$_} ? 
        ( $_ => $_[0]->{$_} )
        : ()
    } @_[1 .. $#_]
  )
}

sub set {
  my $self = shift;
  my @keysidx = grep {; not $_ % 2 } 0 .. $#_ ;
  my @valsidx = grep {; $_ % 2 }     0 .. $#_ ;

  @{$self}{ @_[@keysidx] } = @_[@valsidx];

  $self
}

sub delete {
  blessed_or_pkg($_[0])->array_type->new(
    CORE::delete @{ $_[0] }{ @_[1 .. $#_] }
  )
}

sub keys {
  blessed_or_pkg($_[0])->array_type->new(
    CORE::keys %{ $_[0] }
  )
}

sub values {
  blessed_or_pkg($_[0])->array_type->new(
    CORE::values %{ $_[0] }
  )
}

sub kv {
  blessed_or_pkg($_[0])->array_type->new(
    map {; [ $_, $_[0]->{ $_ } ] } CORE::keys %{ $_[0] }
  )
}

sub kv_sort {
  if (defined $_[1]) {
    return blessed_or_pkg($_[0])->array_type->new(
      map {; [ $_, $_[0]->{ $_ } ] }
        CORE::sort {; $_[1]->($a, $b) } CORE::keys %{ $_[0] }
    )
  }
  blessed_or_pkg($_[0])->array_type->new(
    map {; [ $_, $_[0]->{ $_ } ] } CORE::sort( CORE::keys %{ $_[0] } )
  )
}

sub export { %{ $_[0] } }

1;


=pod

=head1 NAME

List::Objects::WithUtils::Role::Hash - Hash manipulation methods

=head1 SYNOPSIS

  ## Via List::Objects::WithUtils::Hash ->
  use List::Objects::WithUtils 'hash';

  my $hash = hash(foo => 'bar');

  $hash->set(
    foo => 'baz',
    pie => 'tasty',
  );

  my @matches = $hash->keys->grep(sub {
    $_[0] =~ /foo/
  })->all;

  my $pie = $hash->get('pie')
    if $hash->exists('pie');

  for my $pair ( $hash->kv->all ) {
    my ($key, $val) = @$pair;
    ...
  }

  my $obj = $hash->inflate;
  my $foo = $obj->foo;

  ## As a Role ->
  use Role::Tiny::With;
  with 'List::Objects::WithUtils::Role::Hash';

=head1 DESCRIPTION

A L<Role::Tiny> role defining methods for creating and manipulating HASH-type
objects.

In addition to the methods documented below, these objects provide a
C<TO_JSON> method exporting a plain HASH-type reference for convenience when
feeding L<JSON::Tiny> or similar.

=head2 new

Constructs a new HASH-type object.

=head2 export

  my %hash = $hash->export;

Returns a raw key/value list.

=head2 clear

Clears the current hash entirely.

Returns the hash object (as of version 1.013).

=head2 copy

Creates a shallow clone of the current object.

=head2 defined

  if ( $hash->defined($key) ) { ... }

Returns boolean true if the key has a defined value.

=head2 delete

  $hash->delete( @keys );

Deletes keys from the hash.

Returns an L</array_type> object containing the deleted values.

=head2 exists

  if ( $hash->exists($key) ) { ... }

Returns boolean true if the key exists.

=head2 get

  my $val  = $hash->get($key);
  my @vals = $hash->get(@keys)->all;

Retrieves a key or list of keys from the hash.

If we're taking a slice (multiple keys were specified), values are returned
as an L</array_type> object. (See L</sliced> if you'd rather generate a new
hash.)

=head2 inflate

  my $obj = hash(foo => 'bar', baz => 'quux')->inflate;
  my $baz = $obj->baz; 

Inflates a simple object providing accessors for a hash.

By default, accessors are read-only; specifying C<rw => 1> allows setting new
values:

  my $obj = hash(foo => 'bar', baz => 'quux')->inflate(rw => 1);
  $obj->foo('frobulate');

Returns an L</inflated_type> (or L</inflated_rw_type>) object.

The default objects provide a C<DEFLATE> method returning a
plain hash; this makes it easy to turn inflated objects back into a C<hash()>
for modification:

  my $first = hash( foo => 'bar', baz => 'quux' )->inflate;
  my $second = hash( $first->DEFLATE, frobulate => 1 )->inflate;

=head2 is_empty

Returns boolean true if the hash has no keys.

=head2 keys

  my @keys = $hash->keys->all;

Returns the list of keys in the hash as an L</array_type> object.

=head2 values

  my @vals = $hash->values->all;

Returns the list of values in the hash as an L</array_type> object.

=head2 kv

  for my $pair ($hash->kv->all) {
    my ($key, $val) = @$pair;
  }

Returns an L</array_type> object containing the key/value pairs in the HASH,
each of which is a two-element ARRAY.

=head2 kv_sort

  my $kvs = hash(a => 1, b => 2, c => 3)->kv_sort;
  # $kvs = array(
  #          [ a => 1 ], 
  #          [ b => 2 ], 
  #          [ c => 3 ]
  #        )

  my $reversed = hash(a => 1, b => 2, c => 3)
    ->kv_sort(sub { $_[1] cmp $_[0] });
  # Reverse result as above

Like L</kv>, but sorted by key. A sort routine can be provided; C<$_[0]> and
C<$_[1]> are equivalent to the usual sort variables C<$a> and C<$b>.

=head2 set

  $hash->set(
    key1 => $val,
    key2 => $other,
  )

Sets keys in the hash.

As of version 1.007, returns the current hash object.
The return value of prior versions is unreliable.

=head2 sliced

  my $newhash = $hash->sliced(@keys);

Returns a new hash object built from the specified set of keys.

(See L</get> if you only need the values.)

=head2 array_type

The class name of array-type objects that will be used to contain the results
of methods returning a list.

Defaults to L<List::Objects::WithUtils::Array>.

Subclasses can override C<array_type> to produce different types of array
objects; the method can also be queried to find out what kind of array object
will be returned:

  my $type = $hash->array_type;

=head2 inflated_type

The class name that objects are blessed into when calling L</inflate>.

Defaults to L<List::Objects::WithUtils::Hash::Inflated>.

=head2 inflated_rw_type

The class name that objects are blessed into when calling L</inflate> with
C<rw => 1>.

Defaults to L<List::Objects::WithUtils::Hash::Inflated::RW>, a subclass of
L<List::Objects::WithUtils::Hash::Inflated>.

=head1 SEE ALSO

L<List::Objects::WithUtils>

L<Data::Perl>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Portions of this code are derived from L<Data::Perl> by Matthew Phillips
(CPAN: MATTP), haarg et al

Licensed under the same terms as Perl.

=cut
