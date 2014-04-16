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

ok $arr->last_where(sub { /^a$/ }) eq 'a', 'last_where (start) ok';

ok $arr->last_where(sub { /^b/ }) eq 'bb', 'last_where (middle) ok';

ok $arr->last_where(sub { /^c$/ }) eq 'c', 'last_where (end) ok';

ok !$arr->last_where(sub { /d/ }), 'negative last_where ok';

ok !defined array->last_where(sub { 1 }),
  'last_where on empty array returned undef';

done_testing;
