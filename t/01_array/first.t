use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(qw/ a ba bb c /);
my $first = $arr->first(sub { /^b/ });
ok $first eq 'ba', 'first ok';

done_testing;
