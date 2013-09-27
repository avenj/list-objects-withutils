use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(1 .. 3);
cmp_ok $arr->get(0), '==', 1;
cmp_ok $arr->get(1), '==', 2;
cmp_ok $arr->get(2), '==', 3;

done_testing;
