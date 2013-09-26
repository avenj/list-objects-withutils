package List::Objects::WithUtils::Array::Immutable::Typed;
use strictures 1;

require Role::Tiny;
Role::Tiny->apply_roles_to_package( __PACKAGE__,
  qw/
    List::Objects::WithUtils::Role::Array
    List::Objects::WithUtils::Role::Array::WithJunctions
    List::Objects::WithUtils::Role::Array::Typed
    List::Objects::WithUtils::Role::Array::Immutable
  /,
);

use Exporter 'import';
our @EXPORT = 'immarray_of';
sub immarray_of { __PACKAGE__->new(@_) }

1;
