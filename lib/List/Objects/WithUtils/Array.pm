package List::Objects::WithUtils::Array;
use strictures 1;

use Role::Tiny::With;
with 'List::Objects::WithUtils::Role::Array';

use Exporter 'import';
our @EXPORT = 'array';
sub array { __PACKAGE__->new(@_) }

1;
