use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(1 .. 3);
cmp_ok $arr->join, 'eq', '1,2,3', 'join without params ok';
cmp_ok $arr->join('-'), 'eq', '1-2-3', 'join with params ok';

done_testing;
