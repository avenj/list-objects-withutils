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
