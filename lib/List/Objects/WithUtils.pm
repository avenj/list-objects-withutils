package List::Objects::WithUtils;
use Carp;
use strictures 1;

sub import {
  my ($class, @funcs) = @_;
  my $pkg = caller;
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

List::Objects::WithUtils - Object interfaces to lists, with utils

=head1 SYNOPSIS

  use List::Objects::WithUtils;

  my $array = array(qw/ a b c/);
  my $hash  = hash( foo => $bar, snacks => $cake );

See:

L<List::Objects::WithUtils::Role::Array>

L<List::Objects::WithUtils::Role::Hash>

=head1 DESCRIPTION

A small set of roles and classes defining an object-oriented interface to Perl
hashes and arrays. Derived from L<Data::Perl>.

The most commonly used functions from L<List::Util>, L<List::MoreUtils>, and
L<List::UtilsBy> are conveniently provided as chainable methods.

For details on arrays, see L<List::Objects::WithUtils::Array> and
L<List::Objects::WithUtils::Role::Array>.

For details on hashes, see L<List::Objects::WithUtils::Hash> and
L<List::Objects::WithUtils::Role::Hash>.

B<Why another object-oriented list module?>

There are a fair few object-oriented approaches to lists on CPAN, none of
which were quite what I needed. L<Data::Perl> comes the closest -- but is
primarily targetting L<MooX::HandlesVia> and cannot guarantee a reasonably
stable API (and I don't need the other data types).

This module aims to provide a consistent, natural interface to hashes and
arrays exclusively, with convenient access to common tools.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Portions of this code are derived from L<Data::Perl> by Matthew Phillips
(CPAN: MATTP) et al.

Licensed under the same terms as Perl.

=cut
