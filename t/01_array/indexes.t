use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

ok !array->indexes(sub { $_ })->has_any, 'empty indexes ok';

my $arr = array( 1 .. 10 );
my $idx = $arr->indexes(sub { $_ % 2 == 0 });
is_deeply [ $idx->all ], [ 1, 3, 5, 7, 9 ],
  'indexes ok';

done_testing
