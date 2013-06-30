use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'hash';

my $hr = hash();
ok( $hr->does('List::Objects::WithUtils::Role::Hash'),
  'hash obj does role'
);

## array_type()
cmp_ok( $hr->array_type, 'eq', 'List::Objects::WithUtils::Array',
  'array_type() ok'
);

## is_empty()
ok( $hr->is_empty, 'is_empty() ok' );


$hr = hash(foo => 'bar', baz => undef);

## exists()
ok( $hr->exists('foo'), 'key foo exists ok' );
ok( !$hr->exists('pie'), 'key pie nonexistant' );

## defined()
ok( $hr->defined('foo'), 'key foo defined ok');
ok( !$hr->defined('baz'), 'key baz not defined' );

## get()
cmp_ok( $hr->get('foo'), 'eq', 'bar', 'get() ok' );

## copy()
my $copy = $hr->copy;
cmp_ok( $copy->get('foo'), 'eq', 'bar', 'get() on copy ok' );

## sliced()
my $slicable = hash(a => 1, b => 2, c => 3, d => 4);
my $slice = $slicable->sliced('a', 'c', 'z');
isa_ok( $slice, 'List::Objects::WithUtils::Hash',
  'sliced() produced obj'
);
cmp_ok( $slice->keys->count, '==', 2, 'sliced() key count ok' );
ok( !$slice->exists('z'), 'sliced exists(z) ok' );
ok( !$slice->get('b'), 'sliced get(b) ok' );
cmp_ok( $slice->get('a'), '==', 1, 'sliced get(a) ok' );
cmp_ok( $slice->get('c'), '==', 3, 'sliced get(c) ok' );

## keys()
ok(
  ( $hr->keys->grep(sub { $_[0] eq 'foo' })
  && $hr->keys->grep(sub { $_[0] eq 'baz' }) ),
  'keys() ok'
);

## values()
ok(
  ( $hr->values->grep(sub { defined $_[0] and $_[0] eq 'bar' })
  && $hr->values->grep(sub { ! defined($_[0]) }) ),
  'values() ok'
);

## kv()
my $kv = $hr->kv;
my @sorted = $kv->sort_by(sub { $_->[0] })->all;
is_deeply( \@sorted,
  [
    [ baz => undef ],
    [ foo => 'bar' ],
  ],
  'kv() ok'
);

## export()
is_deeply( +{ $hr->export }, +{ foo => 'bar', baz => undef }, 
  'export() ok'
);

## set()
ok $hr->set(snacks => 'tasty') == $hr, 'set() returned self';
cmp_ok( $hr->get('snacks'), 'eq', 'tasty', 'get() after set() ok' );


$hr = hash();

## set(), multi-key
ok( 
  $hr->set(
    a => 1,
    b => 2,
    c => 3,
  ),
  'set multi-key ok'
);
for my $expected (qw/a b c/) {
  ok( 
    $hr->keys->grep(sub { $_[0] eq $expected }),
    "multikey set array has $expected"
  );
}

## get(), multi-key
my $arrget;
ok( $arrget = $hr->get('b', 'c'), 'get multi-key ok' );
for my $expected (qw/B C/) {
  ok(
    $arrget->grep(sub { $_[0] eq $expected }),
    "multikey get array has $expected"
  );
}

## delete()
ok( $hr->set(things => 'stuff'), 'set things ok' );
ok( $hr->delete('things'), 'delete() ok' );
ok( !$hr->get('things'), 'item was deleted' );

## delete(), multi-key
my $deleted;
ok( $deleted = $hr->delete('b', 'c'), 'multikey delete ok' );
cmp_ok( $deleted->count, '==', 2, 'correct number of elements deleted' );

## clear()
$hr->clear;
ok( $hr->is_empty, 'is_empty after clear' );

{ package My::List;
  use strict; use warnings FATAL => 'all';

  require List::Objects::WithUtils::Hash;
  use parent 'List::Objects::WithUtils::Hash';

  package My::Foo;
  use strict; use warnings FATAL => 'all';
  use Test::More;

  my $foo = My::List->new(foo => 1, bar => 2, baz => 3);
  isa_ok( $foo->sliced('foo', 'baz'), 'My::List', 'subclassed obj' );
}

## inflate()
my $obj = hash(foo => 'bar', baz => 'quux')->inflate;
ok $obj->foo eq 'bar', 'accessor on inflated obj ok';
ok $obj->baz eq 'quux', 'accessor on inflated obj ok';
my $cref;
ok ref ($cref = $obj->can('foo')) eq 'CODE', 'can() on inflated obj ok';
ok $obj->$cref eq 'bar', 'can() coderef ok';
ok !$obj->can('cake'), 'negative can() ok';
{ local $@;
  eval {; $obj->set };
  ok $@, 'nonexistant key dies ok';
}
{ local $@;
  eval {; $obj->foo('bar') };
  ok $@, 'read-only dies ok';
}
my %deflated = $obj->DEFLATE;
ok $deflated{foo} eq 'bar', 'deflated HASH looks ok';

my $rwobj = hash(foo => 1, baz => 2)->inflate(rw => 1);
ok $rwobj->foo == 1, 'rw inflated obj accessor read ok';
ok $rwobj->foo('bar') eq 'bar', 'rw inflated obj accessor write ok';
ok $rwobj->foo eq 'bar', 'rw inflated obj accessor rw ok';

done_testing;
