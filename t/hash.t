use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'hash';

my $hr = hash();
## array_type()
cmp_ok( $hr->array_type, 'eq', 'List::Objects::WithUtils::Array' );

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
for my $item ($kv->all) {
  ok( ref $item eq 'ARRAY' && @$item == 2, 'kv item looks ok' )
    or diag explain $item;
}

## export()
is_deeply( +{ $hr->export }, +{ foo => 'bar', baz => undef }, 
  'export() ok'
);

## set()
isa_ok( $hr->set(snacks => 'tasty'), $hr->array_type,
  'set() returned array-type object'
);
cmp_ok( $hr->get('snacks'), 'eq', 'tasty', 'get() after set() ok' );


$hr = hash();

## set(), multi-key
my $arrset;
ok( 
  $arrset = $hr->set(
    a => 1,
    b => 2,
    c => 3,
  ),
  'set multi-key ok'
);
for my $expected (qw/a b c/) {
  ok( 
    $arrset->grep(sub { $_[0] eq $expected }),
    "multikey set array has $expected"
  );
}

## get(), multi-key
my $arrget;
ok( $arrget = $hr->get('b', 'c'), 'get multi-key ok' );
for my $expected (qw/B C/) {
  ok(
    $arrset->grep(sub { $_[0] eq $expected }),
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

done_testing;
