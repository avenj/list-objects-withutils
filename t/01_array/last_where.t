use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(qw/ a ba bb c /);
my $last = $arr->last_where(sub { /^b/ });
ok $last eq 'bb', 'last_where ok';

ok $arr->last_where(sub { /^a$/ }) eq 'a', 'last_where ok';

ok !$arr->last_where(sub { /d/ }), 'negative last_where ok';

done_testing;
