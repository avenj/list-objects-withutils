use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

if ($List::Objects::WithUtils::Role::Array::UsingMoreUtils) {
  diag "\nUsing List::MoreUtils\n"
}

my $arr = array(qw/ a ba bb c /);
my $last = $arr->last_where(sub { /^b/ });
ok $last eq 'bb', 'last_where ok';

ok $arr->last_where(sub { /^a$/ }) eq 'a', 'last_where ok';

ok !$arr->last_where(sub { /d/ }), 'negative last_where ok';

$List::Objects::WithUtils::Role::Array::UsingMoreUtils = 0;
ok $arr->last_where(sub { /^a$/ }) eq 'a', 'last_where ok (without MoreUtils)';
ok !$arr->last_where(sub { /d/ }), 'negative last_where ok (without MoreUtils)';


done_testing;
