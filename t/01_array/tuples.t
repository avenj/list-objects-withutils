use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1 .. 7 );
my $tuples = $arr->tuples(2);
is_deeply
  [ $tuples->all ],
  [
    [ 1, 2 ],
    [ 3, 4 ],
    [ 5, 6 ],
    [ 7 ]
  ],
  'tuples ok';

my $default = $arr->tuples;
is_deeply [ $default->all ], [ $tuples->all ],
  'tuples default 2 ok';

ok array->tuples(2)->is_empty, 'empty array tuples ok';

eval {; $arr->tuples(0) };
like $@, qr/positive/, 'tuples < 1 dies ok';

done_testing;
