use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

if ($List::Objects::WithUtils::Role::Array::UsingMoreUtils) {
  diag "\nUsing List::MoreUtils\n"
}

my $arr = array(qw/ a ba bb c /);
my $firstidx = $arr->firstidx(sub { /^b/ });
ok $firstidx == 1, 'firstidx ok';
ok $arr->first_index(sub { /^b/ }) == $firstidx,
  'first_index alias ok';

ok $arr->first_index(sub { /c/ }) == 3,
  'firstidx ok';

ok $arr->first_index(sub { /d/ }) == -1,
  'negative first_index ok';

$List::Objects::WithUtils::Role::Array::UsingMoreUtils = 0;
ok $arr->first_index(sub { /c/ }) == 3,
  'firstidx ok (without MoreUtils)';

ok $arr->first_index(sub { /d/ }) == -1,
  'negative first_index ok (without MoreUtils)';

done_testing;
