use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'hash';

my $ref = hash(foo => 1, bar => 2)->unbless;
ok ref $ref eq 'HASH', 'unbless returned HASH';
is_deeply $ref, +{ foo => 1, bar => 2 }, 'unbless ok';

done_testing;
