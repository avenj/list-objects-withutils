package List::Objects::WithUtils::Role::Hash::Immutable;
use strictures 1;
use Carp ();
use Hash::Util ();

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

around is_mutable => sub { () };

around new => sub {
  my $orig = shift;
  my $self = $orig->(@_);

  if (my $obj = tied %$self) {
    Role::Tiny->apply_roles_to_object( $obj,
      'List::Objects::WithUtils::Role::Hash::TiedRO'
    );
  }

  Hash::Util::lock_keys(%$self);
  Hash::Util::lock_value(%$self, $_) for keys %$self;

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
  $hash->set(foo => 3);  # dies

=head1 DESCRIPTION

This role adds immutable behavior to L<List::Objects::WithUtils::Role::Hash>
consumers.

The following methods are not available and will throw an exception:

  clear
  set
  delete

The backing hash is also marked read-only, but see L<Hash::Util/"CAVEATS">.

Due to the behavior of L<Hash::Util/"lock_keys">, attempting to fetch a
nonexistant key will also throw an exception. This may change in a future
version. In the meantime, it is safe to check if the key exists first:

  if ( $hash->exists($key) ) {
    my $val = $hash->get($key);
  }

See L<List::Objects::WithUtils::Hash::Immutable> for a consumer
implementation.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
