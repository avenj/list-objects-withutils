use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'hash';

my $hs = hash(
  foo => 1,
  bar => 2,
  baz => 3,
);

my @res;
my $returned = $hs->kv_map(
  sub { push @res, @_; ($_[0], $_[1] + 1) }
);

is_deeply 
  +{ @res }, 
  $hs->unbless, 
  'kv_map input ok';

is_deeply 
  $returned->inflate->unbless,
  +{ foo => 2, bar => 3, baz => 4 },
  'kv_map retval ok';

done_testing
