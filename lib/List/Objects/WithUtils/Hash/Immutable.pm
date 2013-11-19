package List::Objects::WithUtils::Hash::Immutable;
use strictures 1;

require Role::Tiny;
Role::Tiny->apply_roles_to_package( __PACKAGE__,
  qw/
    List::Objects::WithUtils::Role::Hash
    List::Objects::WithUtils::Role::Hash::Immutable
  /,
);

use Exporter 'import';
our @EXPORT = 'immhash';
sub immhash { __PACKAGE__->new(@_) }

1;

=pod

=head1 NAME

List::Objects::WithUtils::Hash::Immutable - Immutable hash objects

=head1 SYNOPSIS

  use List::Objects::WithUtils 'immhash';
  my $hash = immhash( foo => 1, bar => 2 );

=head1 DESCRIPTION

These are immutable hash objects; attempting to call list-mutating methods
will throw an exception.

Due to the behavior of L<Hash::Util/"lock_keys">, attempting to fetch a
nonexistant key will also throw an exception. This may change in a future
version.

This class consumes the following roles, which contain most of the relevant
documentation:

L<List::Objects::WithUtils::Role::Hash>

L<List::Objects::WithUtils::Role::Hash::Immutable>

(See L<List::Objects::WithUtils::Hash> for a mutable implementation.)

=head2 immhash

Creates a new immutable hash object.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
