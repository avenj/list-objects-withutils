use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1 .. 7 );
my $before = $arr->items_before(sub { $_ == 4 });
is_deeply
  [ $before->all ],
  [ 1 .. 3 ],
  'items_before ok';

done_testing;
