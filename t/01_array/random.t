use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(qw/ foo bar /);
my $random = $arr->random;
ok
  $random eq 'foo' || $random eq 'bar',
  'random() ok';

done_testing;
