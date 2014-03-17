use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

if ($List::Objects::WithUtils::Role::Array::UsingMoreUtils) {
  diag "\nUsing List::MoreUtils\n"
}

my $arr = array(qw/ a ba bb c /);
my $lastidx = $arr->lastidx(sub { /^b/ });
ok $lastidx == 2, 'lastidx ok';

ok $arr->last_index(sub { /^b/ }) == $lastidx,
  'last_index alias ok';
ok $arr->last_index(sub { /d/ }) == -1,
  'negative last_index ok';

$List::Objects::WithUtils::Role::Array::UsingMoreUtils = 0;
ok $arr->last_index(sub { /^b/ }) == $lastidx,
  'last_index alias ok (without MoreUtils)';
ok $arr->last_index(sub { /d/ }) == -1,
  'negative last_index ok (without MoreUtils)';

done_testing;
