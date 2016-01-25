use Test::More;
use strict; use warnings;

use Lowu 'hash';

my $hs = hash(a => 1, b => 2, c => 3, d => 4);
my $key = $hs->random_key;
ok $hs->exists($key), 'random_key returned key from hash';

ok !defined hash->random_key, 'empty hash returns undef random_key';

done_testing
