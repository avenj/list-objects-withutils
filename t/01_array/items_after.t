use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1 .. 7 );
my $after = $arr->items_after(sub { $_ == 3 });
is_deeply
  [ $after->all ],
  [ 4 .. 7 ],
  'items_after ok';

done_testing;
