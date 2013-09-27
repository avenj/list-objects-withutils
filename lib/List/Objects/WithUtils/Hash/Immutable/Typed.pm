package List::Objects::WithUtils::Hash::Immutable::Typed;
use strictures 1;

require Role::Tiny;
Role::Tiny->apply_roles_to_package( __PACKAGE__,
  qw/
    List::Objects::WithUtils::Role::Hash
    List::Objects::WithUtils::Role::Hash::Typed
    List::Objects::WithUtils::Role::Hash::Immutable
  /
);

use Exporter 'import';
our @EXPORT = 'immhash_of';
sub immhash_of { __PACKAGE__->new(@_) }


1;
