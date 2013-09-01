package List::Objects::WithUtils;
use Carp;
use strictures 1;

our @DefaultImport = qw/ array immarray hash /;

sub import {
  my ($class, @funcs) = @_;

  my $pkg;
  if (ref $funcs[0]) {
    my %opts = %{ $funcs[0] };
    @funcs = @{ $opts{import} || [ 'all' ] };
    $pkg   = $opts{to} || caller;
  }

  if (!@funcs) {
    @funcs = @DefaultImport
  } elsif (grep {; lc $_ eq 'all' || lc $_ eq ':all' } @funcs) {
    @funcs = ( @DefaultImport, 'autobox', 'array_of' )
  }

  my @mods;
  for my $function (@funcs) {
    if ($function eq 'array') {
      push @mods, 'List::Objects::WithUtils::Array';
      next
    }
    if ($function eq 'hash') {
      push @mods, 'List::Objects::WithUtils::Hash'; 
      next
    }
    if ($function eq 'immarray') {
      push @mods, 'List::Objects::WithUtils::Array::Immutable';
      next
    }
    if ($function eq 'array_of') {
      push @mods, 'List::Objects::WithUtils::Array::Typed';
      next
    }
    if ($function eq 'autobox') {
      # Some unpleasantries required; autobox is weirdly scoped
      require List::Objects::WithUtils::Autobox;
      List::Objects::WithUtils::Autobox::import($class);
      next
    }

    carp "Unknown import parameter '$function'"
  }

  $pkg = caller unless defined $pkg;
  my @failed;
  for my $mod (@mods) {
    my $c = "package $pkg; use $mod;";
    local $@; eval $c;
    if ($@) { carp $@; push @failed, $mod }
  }

  if (@failed) {
    confess 'Failed to import ' . join ', ', @failed
  }

  1
}

print
  qq[ * rjbs is patching PAUSE.\n<rjbs> (to reject anything from peregrin)\n]
unless caller;

1;

=pod

=for Pod::Coverage import

=head1 NAME

List::Objects::WithUtils - List objects with useful methods

=head1 SYNOPSIS

  ## A small sample; consult the description, below, for links to
  ## extended documentation

  # Import selectively:
  use List::Objects::WithUtils 'array';

  # Import 'array()', 'immarray()', 'hash()' object constructors:
  use List::Objects::WithUtils;

  # Import all of the above plus autoboxing:
  use List::Objects::WithUtils ':all';
  # Same, but via convenience shortcut:
  use Lowu;

  # Some simple chained array operations, eventually returning a plain list
  # Most methods returning lists return new objects; chaining is easy:
  array(qw/ aa Ab bb Bc bc /)
    ->grep(sub { /^b/i })
    ->map(sub  { uc })
    ->uniq
    ->all;   # ( 'BB', 'BC' )

  # Useful utilities from other list modules are available:
  my $wanted = array(
    +{ id => '200', user => 'bob' },
    +{ id => '400', user => 'suzy' },
    +{ id => '600', user => 'fred' },
  )->first(sub { $_->{id} > 500 });

  my $sum = array( 1, 2, 3 )->reduce(sub { $_[0] + $_[1] });  # 6

  my $itr = array( 1 .. 7 )->natatime(3);
  while ( my @nextset = $itr->() ) {
    ...
  }

  my $meshed = array(qw/ a b c d /)
    ->mesh( array(1 .. 4) )
    ->all;   # ( 'a', 1, 'b', 2, 'c', 3, 'd', 4 )
  
  my ($evens, $odds) = array( 1 .. 20 )
    ->part(sub { $_[0] & 1 })
    ->all;

  my $sorted = array(
    +{ name => 'bob',  acct => 1 },
    +{ name => 'fred', acct => 2 },
    +{ name => 'suzy', acct => 3 },
  )->sort_by(sub { $_->{name} });

  # array() objects are mutable:
  my $mutable = array(qw/ foo bar baz /);
  $mutable->insert(1, 'quux');
  $mutable->delete(2);

  # ... or use immarray() immutable arrays:
  my $static = immarray( qw/ foo bar baz / );
  $static->set(0, 'quux');  # dies
  $static->[0] = 'quux';    # dies
  push @$static, 'quux';    # dies

  # Simple hash operations; construct a hash:
  my $hash  = hash( foo => 'bar', snacks => 'cake' );
  
  # You can set multiple keys in one call:
  $hash->set( foobar => 'baz', pie => 'cherry' );
  # ... which is useful for merging in another (plain) hash:
  my %foo = ( pie => 'pumpkin', snacks => 'cheese' );
  $hash->set( %foo );
  # ... or another hash object:
  my $second = hash( pie => 'key lime' );
  $hash->set( $second->export );

  # Retrieve one value as a simple scalar:
  my $snacks = $hash->get('snacks');

  # ... or retrieve multiple values as an array-type object:
  my $vals = $hash->get('foo', 'foobar');

  # Take a hash slice of keys, return a new hash object
  # consisting of the retrieved key/value pairs:
  my $slice = $hash->sliced('foo', 'pie');

  # Chained method examples; methods that return multiple values
  # typically return new array-type objects:
  my @match_keys = $hash->keys->grep(sub { m/foo/ })->all;
  my @match_vals = $hash->values->grep(sub { m/bar/ })->all;
  
  my @sorted_pairs = hash( foo => 2, bar => 3, baz => 1)
    ->kv
    ->sort_by(sub { $_->[1] })
    ->all;  # ( [ baz => 1 ], [ foo => 2 ], [ bar => 3 ] )

  # Perl6-inspired Junctions:
  if ( $hash->keys->any_items eq 'snacks' ) {
    ...    
  }
  if ( $hash->values->all_items > 10 ) {
    ...
  }

  # Hashes can be inflated to objects:
  my $obj    = $hash->inflate;
  $snacks = $obj->snacks;

  # Native list types can be autoboxed:
  use List::Objects::WithUtils 'autobox';
  my $foo = [ qw/foo baz bar foo quux/ ]->uniq->sort;
  my $bar = +{ a => 1, b => 2, c => 3 }->values->sort;

  # Autoboxing is lexically scoped like normal:
  { no List::Objects::WithUtils::Autobox;
    [ 1 .. 10 ]->shuffle;  # dies
  }


=head1 DESCRIPTION

A set of roles and classes defining an object-oriented interface to Perl
hashes and arrays with useful utility methods, junctions, and optional
autoboxing.

Originally derived from L<Data::Perl>.

B<array> is imported from L<List::Objects::WithUtils::Array> and creates a new
ARRAY-type object. 
Behavior is defined by L<List::Objects::WithUtils::Role::Array>; look
there for documentation on available methods.

B<immarray> is imported from L<List::Objects::WithUtils::Array::Immutable> and
operates much like an B<array>, except methods that mutate the list are not
available and the backing ARRAY is marked read-only; using immutable arrays 
promotes safer functional patterns.

B<hash> is imported from L<List::Objects::WithUtils::Hash>; see  
L<List::Objects::WithUtils::Role::Hash> for documentation.

Importing B<autobox> lexically enables L<List::Objects::WithUtils::Autobox>,
providing methods for native ARRAY and HASH types.

A bare import list (C<use List::Objects::WithUtils;>) will import the
C<array>, C<immarray>, and C<hash> functions.

Importing B<all> or B<:all> will import all of the above and additionally turn
B<autobox> on, as will the shortcut C<use Lowu;> (as of 1.003).

B<Why another object-oriented list module?>

There are a fair few object-oriented approaches to lists on CPAN, none of
which were quite what I needed. L<Data::Perl> comes the closest -- but is
primarily targetting MooX::HandlesVia and cannot guarantee a stable API at the
time this was written (plus, I don't need the other data types).

This module aims to provide a consistent, natural interface to hashes and
arrays exclusively, with convenient access to common tools. The interface is
expected to remain stable; methods may be added but are
not expected to be removed (or experience incompatible interface changes, barring
serious bugs).

=head1 SEE ALSO

L<List::Objects::WithUtils::Role::Array> for documentation on the basic set of
C<array()> methods.

L<List::Objects::WithUtils::Role::WithJunctions> for documentation on C<array()>
junction-returning methods.

L<List::Objects::WithUtils::Role::Hash> for documentation regarding C<hash()>
methods.

L<List::Objects::WithUtils::Array::Immutable> for more on C<immarray()>
immutable arrays.

L<List::Objects::WithUtils::Autobox> for details on autoboxing.

The L<Lowu> module for a convenient importer shortcut.

L<List::Objects::Types> for relevant L<Type::Tiny> types.

L<MoopsX::ListObjects> for integration with L<Moops> class-building sugar.

=head2 Subclassing

The importer for this package is somewhat flexible; a subclass can override
import to pass import tags and a target package by feeding this package's
C<import()> a HASH:

  # Subclass and import to target packages (see Lowu.pm f.ex):
  package My::Defaults;
  use parent 'List::Objects::WithUtils';
  sub import {
    my ($class, @params) = @_;
    $class->SUPER::import(
      +{
        import => [ 'autobox', 'array', 'hash' ], 
        to     => scalar(caller)
      } 
    )
  }

Functionality is mostly defined by Roles.
For example, it's easy to create your own array class with new methods:

  package My::Array::Object;
  use Role::Tiny::With;
  with 'List::Objects::WithUtils::Role::Array',
       'List::Objects::WithUtils::Role::WithJunctions';

  # An easy way to add your own functional interface:
  use Exporter 'import';  our @EXPORT = 'my_array';
  sub my_array { __PACKAGE__->new(@_) }

  # ... add/override methods ...

... in which case you may want to also define your own hash subclass that
overrides C<array_type> to produce your preferred arrays:

  package My::Hash::Object;
  use Role::Tiny::With;
  with 'List::Objects::WithUtils::Role::Hash';

  use Exporter 'import';  our @EXPORT = 'my_hash';
  sub my_hash { __PACKAGE__->new(@_) }
  
  sub array_type { 'My::Array::Object' }

  # ...
 
=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Licensed under the same terms as Perl.

The original Array and Hash roles were derived from L<Data::Perl> by Matthew
Phillips (CPAN: MATTP), haarg, and others.

Immutable array objects were inspired by L<Const::Fast>.

Junctions are adapted from L<Perl6::Junction> by Carl Franks.

Much of this code simply wraps other widely-used modules, including:

L<List::Util>

L<List::MoreUtils>

L<List::UtilsBy>

=cut
