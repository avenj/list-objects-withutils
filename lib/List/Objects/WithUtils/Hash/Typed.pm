package List::Objects::WithUtils::Hash::Typed;
use strictures 1;

require Role::Tiny;
Role::Tiny->apply_roles_to_package( __PACKAGE__,
  qw/
    List::Objects::WithUtils::Role::Hash
    List::Objects::WithUtils::Role::Hash::Typed
  /
);

use Exporter 'import';
our @EXPORT = 'hash_of';
sub hash_of { __PACKAGE__->new(@_) }

1;
