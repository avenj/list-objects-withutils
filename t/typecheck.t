
BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}

use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils;

use List::Objects::Types -all;
use Types::Standard -all;

# tuples
{
  my $arr = array(qw/foo bar baz quux/);
  my $tuples;
  ok $tuples = $arr->tuples(2 => Str), 'Str check ok';
  is_deeply(
    [ $tuples->all ],
    [ [ foo => 'bar' ], [ baz => 'quux' ] ],
    'tuple array after Str check ok'
  );

  eval {; $tuples = $arr->tuples(2, Int) };
  ok $@, 'Int check failed ok';
  ok $@ =~ m/type/i, 'Int check failed with type err'
    or diag explain $@;

  $arr = array( [], [], [], [] );
  ok $tuples = $arr->tuples(2, ArrayObj), 'ArrayObj coercion ok';  
  ok $tuples->shift->[0]->count == 0, 'ArrayObj was coerced';
}

# validated
{
  my $arr = array(qw/foo bar baz quux/);
  my $valid;
  ok $valid = $arr->validated(Str), 'validated Str ok';
  is_deeply(
    [ $valid->all ],
    [ qw/foo bar baz quux/ ],
    'validated(Str) returned array ok'
  );

  eval {; $valid = $arr->validated(Int) };
  ok $@, 'validated Int died ok';
  ok $@ =~ m/type/i, 'Int check failed with type err'
    or diag explain $@;
}


done_testing;
