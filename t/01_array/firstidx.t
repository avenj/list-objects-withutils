use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(qw/ a ba bb c /);
my $firstidx = $arr->firstidx(sub { /^b/ });
ok $firstidx == 1, 'firstidx ok';
ok $arr->first_index(sub { /^b/ }) == $firstidx,
    'first_index alias ok';

done_testing;
