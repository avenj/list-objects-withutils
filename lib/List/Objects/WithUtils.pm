package List::Objects::WithUtils;
use Carp;
use strictures 1;

sub import {
  my ($class, @funcs) = @_;
  @funcs = qw/ array hash / unless @funcs;

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
  }

  my $pkg = caller;
  my @failed;
  for my $mod (@mods) {
    my $c = "package $pkg; use $mod;";
    eval $c;
    if ($@) { carp $@; push @failed, $mod }
  }

  confess "Failed to import ".join ', ', @failed if @failed;

  1
}


1;

=pod

=for Pod::Coverage import

=head1 NAME

List::Objects::WithUtils - Object interfaces to lists with useful methods

=head1 SYNOPSIS

  use List::Objects::WithUtils;

  my $array = array(qw/ aa Ab bb Bc bc /);
  my @upper = $array->grep(
      sub { $_[0] =~ /^b/i }
    )->map(
      sub { uc $_[0] }
  )->uniq->all;  # @upper = ( 'BB', 'BC' )

  my $hash  = hash( foo => 'bar', snacks => 'cake' );
  my @matching = $hash->keys->grep(sub { $_[0] =~ /foo/ })->all;

=head1 DESCRIPTION

A small set of roles and classes defining an object-oriented interface to Perl
hashes and arrays. Derived from L<Data::Perl>.

Some commonly used functions from L<List::Util>, L<List::MoreUtils>, and
L<List::UtilsBy> are conveniently provided as methods.

See:

L<List::Objects::WithUtils::Role::Array>

L<List::Objects::WithUtils::Role::WithJunctions>

L<List::Objects::WithUtils::Role::Hash>

B<array> is imported from L<List::Objects::WithUtils::Array> and creates a new
ARRAY-type object. 
Behavior is defined by L<List::Objects::WithUtils::Role::Array>; look
there for documentation on available methods.

B<hash> is imported from L<List::Objects::WithUtils::Hash>; see  
L<List::Objects::WithUtils::Role::Hash> for documentation.

B<Why another object-oriented list module?>

There are a fair few object-oriented approaches to lists on CPAN, none of
which were quite what I needed. L<Data::Perl> comes the closest -- but is
primarily targetting MooX::HandlesVia and cannot guarantee a reasonably
stable API (and I don't need the other data types).

This module aims to provide a consistent, natural interface to hashes and
arrays exclusively, with convenient access to common tools. The interface is
expected to remain stable; methods may be added but are
not expected to be removed (or experience incompatible interface changes, barring
serious bugs).

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Significant portions of this code are derived from L<Data::Perl> 
by Matthew Phillips (CPAN: MATTP), haarg, and others.

Licensed under the same terms as Perl.

=cut
