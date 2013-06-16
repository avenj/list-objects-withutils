package List::Objects::WithUtils;
use Carp;
use strictures 1;

our @DefaultImport = qw/ array immarray hash /;

sub import {
  my ($class, @funcs) = @_;

  my $pkg;
  if (ref $funcs[0] eq 'HASH') {
    # Undocumented currently, but you can import to elsewhere:
    #  use parent 'List::Objects::WithUtils';
    #  sub import {
    #    my ($class, @params) = @_;
    #    $class->SUPER::import({ import => \@params, to => scalar(caller) })
    #  }
    # (see Lowu.pm f.ex)
    my $opts = $funcs[0];
    @funcs = @{ $opts->{import} || [ 'all' ] };
    $pkg   = $opts->{to} || caller;
  }

  if (!@funcs) {
    @funcs = @DefaultImport
  } elsif (grep {; lc $_ eq 'all' || lc $_ eq ':all' } @funcs) {
    @funcs = ( @DefaultImport, 'autobox' )
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
    if ($function eq 'autobox') {
      # Some unpleasantries required; autobox is weirdly scoped
      require List::Objects::WithUtils::Autobox;
      List::Objects::WithUtils::Autobox::import($class);
      next
    }
  }

  $pkg = caller unless defined $pkg;
  my @failed;
  for my $mod (@mods) {
    my $c = "package $pkg; use $mod;";
    local $@; eval $c;
    if ($@) { carp $@; push @failed, $mod }
  }

  confess "Failed to import ".join ', ', @failed if @failed;

  1
}

print
  qq[ * rjbs is patching PAUSE.\n<rjbs> (to reject anything from peregrin)\n]
unless caller;

1;

=pod

=for Pod::Coverage import

=head1 NAME

List::Objects::WithUtils - Object interfaces to lists with useful methods

=head1 SYNOPSIS

  ## A very small sampling; consult the description, below, for links to
  ## extended documentation:

  # Import selectively:
  use List::Objects::WithUtils 'array';

  # Import 'array()', 'immarray()', 'hash()' object constructors:
  use List::Objects::WithUtils;

  # Import all of the above plus autoboxing:
  use List::Objects::WithUtils ':all';
  # Same, but via convenience shortcut:
  use Lowu;

  # Some simple chained array operations, eventually returning a plain list:
  array(qw/ aa Ab bb Bc bc /)
    ->grep(sub { $_[0] =~ /^b/i })
    ->map(sub { uc $_[0] })
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

  # Array objects can be immutable:
  my $static = immarray( qw/ foo bar baz / );
  $static->set(0, 'quux');  # dies
  $static->[0] = 'quux';    # dies
  push @$static, 'quux';    # dies

  # Simple hash operations; construct a hash:
  my $hash  = hash( foo => 'bar', snacks => 'cake' );
  
  # Set multiple keys:
  $hash->set( foobar => 'baz', pie => 'tasty' );

  # Retrieve one value as a simple scalar:
  my $snacks = $hash->get('snacks');

  # Retrieve multiple values as an array-type object:
  my $vals = $hash->get('foo', 'foobar');

  # Take a hash slice of keys/values, return a new hash object:
  my $slice = $hash->sliced('foo', 'pie');

  # Hash methods returning arrays returning arrays . . .
  my @matching = $hash->keys->grep(sub { $_[0] =~ /foo/ })->all;

  # Perl6-inspired Junctions:
  if ( $hash->keys->any_items eq 'snacks' ) {
    ...    
  }

  # Autoboxed native data types:
  use List::Objects::WithUtils 'autobox';
  my $foo = [ qw/foo baz bar foo quux/ ]->uniq->sort;
  my $bar = +{ a => 1, b => 2, c => 3 }->values->sort;

  # Autoboxing is lexically scoped like normal:
  { no List::Objects::WithUtils::Autobox;
    [ 1 .. 10 ]->shuffle;  # dies
  }

=head1 DESCRIPTION

A set of roles and classes defining an object-oriented interface to Perl
hashes and arrays. Originally derived from L<Data::Perl>.

Some commonly used functions from L<List::Util>, L<List::MoreUtils>, and
L<List::UtilsBy> are conveniently provided as methods. Junctions, 
as provided by L<Syntax::Keyword::Junction>, are also available.

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

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Licensed under the same terms as Perl.

The original Array and Hash roles were derived from L<Data::Perl> by Matthew
Phillips (CPAN: MATTP), haarg, and others.

Immutable array objects were inspired by L<Const::Fast>.

Most of this code relies entirely on other widely-used modules, including:

L<List::Util>

L<List::MoreUtils>

L<List::UtilsBy>

L<Syntax::Keyword::Junction>

=cut
