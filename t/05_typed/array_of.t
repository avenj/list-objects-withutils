
BEGIN {
  unless (eval {; require Types::Standard; 1 }   && !$@) {
    require Test::More;
    Test::More::plan(skip_all =>
      'these tests require Types::Standard'
    );
  }
}

use Test::More;
use strict; use warnings FATAL => 'all';

use Types::Standard -all;

# array_of
{
  use List::Objects::WithUtils 'array', 'array_of';
  my $arr = array_of Int() => 1 .. 3;
  ok $arr->type == Int, 'type returned Int ok';
  ok !array->type, 'plain ArrayObj has no type ok';

  eval {; my $bad = array_of( Int() => qw/foo 1 2/) };
  ok $@ =~ /constraint/, 'array_of invalid type died ok' or diag explain $@;

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

  eval {; $arr->insert(0 => 'foo') };
  ok $@ =~ /type/, 'invalid type insert died ok';
  ok $arr->insert(0 => 1), 'valid type insert ok';

  eval {; $arr->splice(0, 1, 'foo') };
  ok $@ =~ /type/, 'invalid type splice died ok';
  ok $arr->splice(0, 1, 2), 'valid type splice ok';
  ok $arr->splice(0, 1),    'splice without value ok';

  eval {; $arr->map(sub { 'foo' }) };
  ok $@ =~ /type/, 'invalid reconstruction died ok';
  my $mapped;
  ok $mapped = $arr->map(sub { 1 }), 'valid type reconstruction ok';
  isa_ok $mapped, 'List::Objects::WithUtils::Array::Typed';
  ok $arr->type == $mapped->type, 'reconstructed obj has same type';
  my $copy = $arr->copy;
  ok $copy->type == $arr->type, 'copy has same type ok';
  is_deeply [ $copy->export ], [ $arr->export ],
    'copy ok';
}

# tied array
{
  use List::Objects::WithUtils 'array_of';
  my $arr = array_of Int() => 1 .. 3;

  eval {; push @$arr, 'foo' };
  ok $@ =~ /type/, 'invalid type push died ok';
  push @$arr, 4 .. 6;
  ok $arr->count == 6, 'count ok after push';

  eval {; unshift @$arr, 'bar' };
  ok $@ =~ /type/, 'invalid type unshift died ok';
  unshift @$arr, 7 .. 9;
  ok $arr->count == 9, 'count ok after unshift';

  eval {; $arr->[0] = 'foo' };
  ok $@ =~ /type/, 'invalid type set died ok';
  $arr->[0] = 42;
  is $arr->[0], 42, 'valid type set ok';
}


done_testing;
