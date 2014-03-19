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

my $arr = array( 1 .. 7 );
my $before = $arr->items_before(sub { $_ == 4 });
is_deeply
  [ $before->all ],
  [ 1 .. 3 ],
  'items_before ok';

done_testing;
