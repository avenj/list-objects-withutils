use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'hash';
my $hr = hash;
ok $hr->set( snacks => 'tasty') == $hr, 'set returned self';
ok $hr->get('snacks') eq 'tasty', 'set ok';

$hr->set( a => 1, b => 2, c => 3 );
is_deeply
  +{ $hr->export },
  +{ a => 1, b => 2, c => 3, snacks => 'tasty' },
  'multi-key set ok';

done_testing;
