use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array;
$arr->insert(0 => 1);
is_deeply
  [ $arr->all ],
  [ 1 ],
  'insert on empty list ok';

$arr->insert(4 => 2);
is_deeply
  [ $arr->all ],
  [ 1, undef, undef, undef, 2 ],
  'insert pre-filled nonexistant elems ok';

$arr->insert(3 => 3);
is_deeply
  [ $arr->all ],
  [ 1, undef, undef, 3, undef, 2 ],
  'insert ok';

$arr->insert(5 => 5);
is_deeply
  [ $arr->all ],
  [ 1, undef, undef, 3, undef, 5, 2 ],
  'insert next-to-last ok';

$arr->insert( 7 => 7 );
is_deeply
  [ $arr->all ],
  [ 1, undef, undef, 3, undef, 5, 2, 7 ],
  'insert last ok';

$arr = array( 1, 3, 4 );
my $insert = $arr->insert(1 => 2);
is_deeply
  [ $arr->all ],
  [ 1, 2, 3, 4 ],
  'insert ok';
ok $insert == $arr, 'insert returned self';

done_testing;
