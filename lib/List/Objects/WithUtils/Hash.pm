package List::Objects::WithUtils::Hash;
use strictures 1;

use Role::Tiny::With;
with 'List::Objects::WithUtils::Role::Hash';

use Exporter 'import';
our @EXPORT = 'hash';
sub hash { __PACKAGE__->new(@_) }

1;
