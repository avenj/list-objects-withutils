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

my $arr = array( 1, 2, 2, 3, 4, 5, 5 );
my $uniq = $arr->uniq;
is_deeply
  [ $uniq->sort->all ],
  [ 1, 2, 3, 4, 5 ],
  'uniq ok';

done_testing;
