use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'valarray';

my $arr = valarray;

isa_ok( $arr, 'List::Objects::WithUtils::Array::Immutable' );
isa_ok( $arr, 'List::Objects::WithUtils::Array' );

cmp_ok( $arr->count, '==', 0, 'size 0 ok' );
$arr = valarray(qw/ a b c /);
cmp_ok( $arr->count, '==', 3, 'size 3 ok' );

## head
my $first = $arr->head;
cmp_ok( $first, 'eq', 'a', 'scalar head() ok' );
my ($head, $tail) = $arr->head;
cmp_ok( $head, 'eq', 'a', 'list head() head ok' );
cmp_ok( $tail->count, '==', 2, 'list head() tail size ok' );
is_deeply(
  [ $tail->all ],
  [ 'b', 'c' ],
  'list head() tail looks ok'
);

($head, $tail) = $tail->head;
cmp_ok( $head, 'eq', 'b', 'list head() on prev tail head ok' );
cmp_ok( $tail->count, '==', 1, 'list head() on prev tail size ok' );

## tail
undef $head; undef $tail; my $rest;
($tail, $rest) = $arr->tail;
cmp_ok( $tail, 'eq', 'c', 'list tail() tail ok' );
cmp_ok( $rest->count, '==', 2, 'list tail() remainder size ok' );
is_deeply(
  [ $rest->all ],
  [ 'a', 'b' ],
  'list tail() tail looks ok'
);

## unimplemented
my @unimpl = qw/
  set
  pop push
  shift unshift
  clear delete
  insert splice
/;

for my $method (@unimpl) {
  eval {; $arr->$method };
  ok( $@ =~ /implemented/, "$method dies" );
}

done_testing;
