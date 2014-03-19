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
my $after = $arr->items_after_incl(sub { $_ == 3 });
is_deeply
  [ $after->all ],
  [ 3 .. 7 ],
  'items_after_incl ok';

done_testing;
