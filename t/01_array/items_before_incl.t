use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1 .. 7 );
my $before = $arr->items_before_incl(sub { $_ == 4 });
is_deeply
  [ $before->all ],
  [ 1 .. 4 ],
  'items_before_incl ok';

done_testing;
