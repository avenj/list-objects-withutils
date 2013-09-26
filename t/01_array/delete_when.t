use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1, 2, 1, 1, 3, 4, 1 );
my $deleted = $arr->delete_when(sub { $_ == 1 });
is_deeply [ $deleted->all ], [ (1) x 4 ], 
  'delete_when returned correct values';
is_deeply [ $arr->all ], [ 2, 3, 4 ],
  'delete_when deleted correct values';

$arr->delete_when(sub { $_[0] == 2 });
is_deeply [ $arr->all ], [ 3, 4 ],
  'delete_when using $_[0] ok';

done_testing;
