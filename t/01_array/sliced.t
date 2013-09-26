use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1 .. 5 );
my $sliced = $arr->sliced(0, 2);
is_deeply
  [ $sliced->all ],
  [ 1, 3 ],
  'sliced ok';

done_testing;
