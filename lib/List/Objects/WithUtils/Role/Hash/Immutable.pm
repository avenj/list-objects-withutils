package List::Objects::WithUtils::Role::Hash::Immutable;
use strictures 1;
use Carp ();

sub _make_unimp {
  my ($method) = @_;
  sub {
    local $Carp::CarpLevel = 1;
    Carp::croak "Method '$method' not implemented on immutable hashes"
  }
}

our @ImmutableMethods = qw/
  clear
  set
  delete
/;

use Role::Tiny;
requires 'new', @ImmutableMethods;

around new => sub {
  my $orig = shift;
  my $self = $orig->(@_);

  &Internals::SvREADONLY($self, 1);
  Internals::SvREADONLY($_, 1) for values %$self;

  $self
};

around $_ => _make_unimp($_) for @ImmutableMethods;

1;

=pod

=head1 NAME

List::Objects::WithUtils::Role::Hash::Immutable - Immutable hash behavior

=head1 SYNOPSIS

  # Via List::Objects::WithUtils::Hash::Immutable ->
  use List::Objects::WithUtils 'immhash';
  my $hash = immhash( foo => 1, bar => 2 );

=head1 DESCRIPTION

This role adds immutable behavior to L<List::Objects::WithUtils::Role::Hash>
consumers.

The following methods are not available and will throw an exception:

  clear
  set
  delete

See L<List::Objects::WithUtils::Hash::Immutable> for a consumer
implementation.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
