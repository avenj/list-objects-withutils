use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $ref = array(1 .. 3)->unbless;
ok ref $ref eq 'ARRAY', 'unbless returned ARRAY';
is_deeply $ref, [ 1 .. 3 ], 'unbless ok';

done_testing;
