use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils;

my $arr = immarray;

isa_ok( $arr, 'List::Objects::WithUtils::Array::Immutable' );
isa_ok( $arr, 'List::Objects::WithUtils::Array' );

cmp_ok( $arr->count, '==', 0, 'size 0 ok' );
$arr = immarray(qw/ a b c /);
cmp_ok( $arr->count, '==', 3, 'size 3 ok' );

## head
my $first = $arr->head;
cmp_ok( $first, 'eq', 'a', 'scalar head() ok' );
my ($head, $tail) = $arr->head;
isa_ok( $tail, 'List::Objects::WithUtils::Array::Immutable',
  '->head() produced obj'
);
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
  local $@;
  eval {; $arr->$method };
  ok( $@ =~ /implemented/, "$method dies" );
}

## readonly
{ local $@;
  my $imm = immarray(qw/ a b c/);
  eval {; push @$imm, 'bar' };
  ok( $@ =~ /read-only/, 'attempt to modify died' );
}

my $with_hash = immarray( hash( foo => 'bar' ) );
ok( $with_hash->get(0)->get('foo') eq 'bar', 'hash in immarray ok' );
ok( $with_hash->get(0)->set(foo => 'baz'), 'hash->set in immarray ok' );
ok( $with_hash->get(0)->get('foo') eq 'baz', 'hash->get in immarray ok' );
{ local $@;
  eval {; $with_hash->[0] = 'foo' };
  ok( $@ =~ /read-only/, 'attempt to modify 2 died' );
}

my $with_arr = immarray( array( qw/ a b c / ) );
ok( $with_arr->get(0)->set(0, 'foo'), 'mutable set() inside immutable list ok');
{ local $@;
  eval {; $with_arr->[0] = 'bar' };
  ok( $@ =~ /read-only/, 'attempt to modify 3 died' );
}

undef $with_arr;
$with_arr = immarray( [ qw/ a b c/ ] );
ok( ref $with_arr->get(0) eq 'ARRAY', 'non-objs remain unblessed' );

done_testing;
