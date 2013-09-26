use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1 .. 4 );
my $deleted = $arr->delete(2);
cmp_ok $deleted, '==', 3, 'delete returned correct value';
is_deeply [ $arr->all ], [ 1, 2, 4 ], 'value was deleted';

done_testing;
