use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(1, 2, 3);
my $set = $arr->set( 1 => 'foo' );
ok $arr == $set, 'set returned self';
is_deeply
  [ $arr->all ],
  [ 1, 'foo', 3 ],
  'set ok';

done_testing;
