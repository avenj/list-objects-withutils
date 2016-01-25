use Test::More;
use strict; use warnings;

use Lowu 'hash';

my $hs = hash(a => 1, b => 2, c => 3);
my $kv = $hs->random_kv;

cmp_ok ref $kv, 'eq', 'ARRAY', 'random_kv returned ARRAY';
my ($key, $val) = @$kv;

ok $hs->exists($key), 'randomly retrieved key exists';
cmp_ok $hs->get($key), '==', $val, 'retrieved value matches key';

done_testing
