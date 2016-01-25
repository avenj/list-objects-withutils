use Test::More;
use strict; use warnings;

use Lowu 'hash';

my $hs  = hash(a => 1, b => 2, c => 3, d => 4);
my $rev = $hs->inverted;
my $val = $hs->random_value;
ok $rev->exists($val), 'random_value exists in hash';

ok !defined hash->random_value, 'empty hash returns undef random_value';

done_testing
