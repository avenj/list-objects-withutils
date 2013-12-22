use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(qw/ a ba bb c /);
my $lastidx = $arr->lastidx(sub { /^b/ });
ok $lastidx == 2, 'lastidx ok';
ok $arr->last_index(sub { /^b/ }) == $lastidx,
  'last_index alias ok';

done_testing;
