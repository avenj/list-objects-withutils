use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(4, 2, 3, 1);
my $sorted = $arr->sort(sub { $_[0] <=> $_[1] });
is_deeply
  [ $sorted->all ],
  [ 1, 2, 3, 4 ],
  'sort ok';

$sorted = $arr->sort;
is_deeply
  [ $sorted->all ],
  [ 1, 2, 3, 4 ],
  'sort with default sub ok';

done_testing;