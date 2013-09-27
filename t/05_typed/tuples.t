
BEGIN {
  unless (
    eval {; require List::Objects::Types; 1 } && !$@
    && eval {; require Types::Standard; 1 }   && !$@
  ) {
    require Test::More;
    Test::More::plan(skip_all =>
      'these tests require List::Objects::Types and Types::Standard'
    );
  }
}

use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::Types -all;
use Types::Standard -all;

use List::Objects::WithUtils 'array';

my $arr = array(qw/ foo bar baz quux /);
my $tuples = $arr->tuples(2 => Str);
is_deeply
  [ $tuples->all ],
  [ [ foo => 'bar' ], [ baz => 'quux' ] ],
  'tuples with Str check ok';

eval {; $tuples = $arr->tuples(2, Int) };
ok $@ =~ /type/i, 'Int check failed with type err'
  or diag explain $@;

$arr = array( [], [], [], [] );
$tuples = $arr->tuples(2, ArrayObj);
ok $tuples->shift->[0]->count == 0, 'ArrayObj coerced in tuple';

eval {; $tuples = $arr->tuples(3, ArrayObj) };
ok $@ =~ /type/i, 'ArrayObj check failed on odd tuple ok';

done_testing;
