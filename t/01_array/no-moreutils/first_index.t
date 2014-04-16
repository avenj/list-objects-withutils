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
my $firstidx = $arr->firstidx(sub { /^b/ });
ok $firstidx == 1, 'firstidx ok';
ok $arr->first_index(sub { /^b/ }) == $firstidx,
  'first_index alias ok';

ok $arr->first_index(sub { /c/ }) == 3,
  'firstidx ok';

ok $arr->first_index(sub { /d/ }) == -1,
  'negative first_index ok';

ok array->first_index(sub { 1 }) == -1,
  'empty array first_index ok';

done_testing;
