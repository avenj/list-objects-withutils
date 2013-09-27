use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(1 .. 3);
cmp_ok $arr->reduce(sub { $_[0] + $_[1] }), '==', 6,
  'reduce ok';

done_testing;
