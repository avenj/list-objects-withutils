use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1 .. 7 );
my $sliced = $arr->sliced(0, 2);
is_deeply
  [ $sliced->all ],
  [ 1, 3 ],
  'sliced (2 element) ok';

$sliced = $arr->sliced(0, 2, 4);
is_deeply
  [ $sliced->all ],
  [ 1, 3, 5 ],
  'sliced (3 element) ok';

is_deeply
  [ $arr->slice(0, 2, 4)->all ],
  [ $sliced->all ],
  'slice alias ok';

done_testing
