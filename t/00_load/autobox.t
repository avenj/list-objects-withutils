use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'autobox';

cmp_ok []->count, '==', 0, 'autobox ok';

done_testing;
