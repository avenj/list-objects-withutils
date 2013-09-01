
BEGIN {
  unless (
    eval {; require List::Objects::Types; 1 }
    && eval {; require Types::Standard; 1 }
    && !$@
  ) {
    require Test::More;
    Test::More::plan(skip_all => 
      'these tests require List::Objects::Types'
    );
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

# array_of
{
  use List::Objects::WithUtils 'array_of';
  my $arr = array_of( Int() => 1 .. 3 );
  
  eval {; my $bad = array_of( Int() => qw/foo 1 2/) };
  ok $@ =~ /type/, 'array_of invalid type died ok'
    or diag explain $@;
  
  eval {; $arr->push('foo') };
  ok $@ =~ /type/, 'invalid type push died ok';
  ok $arr->push(4 .. 6), 'valid type push ok';
  ok $arr->count == 6, 'count ok after push';

  eval {; $arr->unshift('bar') };
  ok $@ =~ /type/, 'invalid type unshift died ok';
  ok $arr->unshift(7 .. 9), 'valid type unshift ok';
  ok $arr->count == 9, 'count ok after unshift';

  eval {; $arr->set(0 => 'foo') };
  ok $@ =~ /type/, 'invalid type set died ok';
  ok $arr->set(0 => 0), 'valid type set ok';

  eval {; $arr->map(sub { 'foo' }) };
  ok $@ =~ /type/, 'invalid reconstruction died ok';
  my $mapped;
  ok $mapped = $arr->map(sub { 1 }), 'valid type reconstruction ok';
  isa_ok $mapped, 'List::Objects::WithUtils::Array::Typed';
}


done_testing;
