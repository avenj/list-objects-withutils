use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1, 3, 4 );
my $insert = $arr->insert(1 => 2);
is_deeply
  [ $arr->all ],
  [ 1, 2, 3, 4 ],
  'insert ok';
ok $insert == $arr, 'insert returned self';

done_testing;
