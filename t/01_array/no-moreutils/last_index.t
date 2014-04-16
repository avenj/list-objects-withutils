use strict; use warnings FATAL => 'all';

BEGIN {
  unless (eval {; require Test::Without::Module; 1 } && !$@) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests require Test::Without::Module');
  }
}

use Test::Without::Module 'List::MoreUtils';
use Test::More;

use List::Objects::WithUtils 'array';

my $arr = array(qw/ a ba bb c /);

ok $arr->lastidx(sub { /^b/ }) == 2,
  'lastidx ok';

ok $arr->last_index(sub { /^b/ }) == 2,
  'last_index alias ok';

ok $arr->last_index(sub { /d/ }) == -1,
  'negative last_index ok';

ok array->last_index(sub { 1 }) == -1,
  'last_index on empty array ok';

done_testing;
