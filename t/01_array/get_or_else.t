use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array( 1 .. 3 );

cmp_ok $arr->get_or_else(0), '==', 1,
  'get_or_else existing element ok';

ok !$arr->get_or_else(3), 
  'get_or_else nonexistant element without default';

cmp_ok $arr->get_or_else(3 => 'foo'), 'eq', 'foo',
  'get_or_else defaults to scalar ok';

my $invoc;
cmp_ok $arr->get_or_else(3 => sub { $invoc = shift; 'foo' }), 'eq', 'foo',
  'get_or_else with coderef ok';

cmp_ok $invoc, '==', $arr,
  'get_or_else coderef invocant ok';

done_testing;
