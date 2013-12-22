use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(qw/ a ba bb c /);
my $last = $arr->last_where(sub { /^b/ });
ok $last eq 'bb', 'last ok';

done_testing;
