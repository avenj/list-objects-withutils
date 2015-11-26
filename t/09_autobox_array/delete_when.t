use Test::More;
use strict; use warnings FATAL => 'all';

use Lowu;

my $arr = [ 1, 2, 1, 1, 3, 4, 1 ];

my $deleted = $arr->delete_when(sub { $_ == 1 });

is_deeply [ $deleted->all ], [ (1) x 4 ], 
  'boxed delete_when returned correct values';

is_deeply [ $arr->all ], [ 2, 3, 4 ],
  'boxed delete_when deleted correct values';

$arr->delete_when(sub { $_[0] == 2 });
is_deeply [ $arr->all ], [ 3, 4 ],
  'boxed delete_when using @_ ok';

$deleted = $arr->delete_when(sub { $_ == 10 });
is_deeply [ $arr->all ], [ 3, 4 ],
  'boxed delete_when deleted nothing ok';

is_deeply [ $deleted->all ], [],
  'boxed delete_when deleted nothing ok';

$arr = [];
$deleted = $arr->delete_when(sub { $_ == 2 });
ok $deleted->is_empty, 'boxed delete_when on empty list ok';
ok $arr->is_empty,     'boxed delete_when on empty list left list alone';

done_testing;
