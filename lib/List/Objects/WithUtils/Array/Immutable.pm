package List::Objects::WithUtils::Array::Immutable;
use strictures 1;

use Role::Tiny::With;
require List::Objects::WithUtils::Array;

our @ISA = 'List::Objects::WithUtils::Array';
with 'List::Objects::WithUtils::Role::Immutable';

use Exporter 'import';
our @EXPORT = 'arrayval';
sub arrayval { __PACKAGE__->new(@_) }

1;
