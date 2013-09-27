use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $arr = array(qw/ a b c /);

my $first = $arr->head;
ok $first eq 'a', 'scalar head ok';

my ($head, $tail) = $arr->head;
isa_ok $tail, 'List::Objects::WithUtils::Array';

ok $head eq 'a', 'list head first item ok';
is_deeply
  [ $tail->all ],
  [ qw/ b c / ],
  'list head second item ok';

done_testing;
