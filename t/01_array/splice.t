use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(qw/ a b c d /);
my $spliced = $arr->splice(1, 3);
is_deeply
  [ $spliced->all ],
  [ qw/ b c d / ],
  '2-arg splice ok';

$spliced->splice(2, 1, 'e');
is_deeply
  [ $spliced->all ],
  [ qw/ b c e / ],
  '3-arg splice ok';

done_testing;
