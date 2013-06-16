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

  use List::Objects::WithUtils;

  # Chained array operations:
  array(qw/ aa Ab bb Bc bc /)
    ->grep(sub { $_[0] =~ /^b/i })
    ->map( sub { uc $_[0] })
    ->uniq
    ->all;     # ( 'BB', 'BC' )

  # Sample hash operations:
  my $hash  = hash( foo => 'bar', snacks => 'cake' );  

  $hash->set( foobar => 'baz', pie => 'tasty' );

  my $snacks = $hash->get('snacks');

  my $slice = $hash->sliced('foo', 'pie');

  # Hash operations returning array objects:
  my @matching = $hash->keys->grep(sub { $_[0] =~ /foo/ })->all;

  if ( $hash->keys->any_items eq 'snacks' ) {
    ...    
  }

  # Autoboxed:
  use List::Objects::WithUtils 'autobox';
  my $foo = [ qw/foo baz bar foo quux/ ]->uniq->sort;

=head1 DESCRIPTION

A small set of roles and classes defining an object-oriented interface to Perl
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
B<array>, B<immarray>, and B<hash> functions.
Importing B<all> or B<:all> will import all of the above and additionally turn
B<autobox> on.

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

L<List::Objects::WithUtils::Role::Array> for documentation on C<array()>
methods.

L<List::Objects::WithUtils::Role::WithJunctions> for details regarding using 
junctions on an C<array()>.

L<List::Objects::WithUtils::Role::Hash> for documentation on C<hash()>
methods.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Significant portions of this code are derived from L<Data::Perl> 
by Matthew Phillips (CPAN: MATTP), haarg, and others.

Licensed under the same terms as Perl.

=cut
