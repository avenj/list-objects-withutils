use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

## count()
my $arr = array;
cmp_ok( $arr->count, '==', 0, 'size 0 ok' );
$arr = array(1);
cmp_ok( $arr->count, '==', 1, 'size 1 ok' );
$arr = array(1,2,3);
cmp_ok( $arr->count, '==', 3, 'size 3 ok' );

## copy()
my $copy = $arr->copy;
cmp_ok( $copy->count, '==', 3, 'copy size 3 ok' );

## is_empty()
ok( array()->is_empty, 'is_empty ok' );
ok( !$arr->is_empty, 'negative is_empty ok' );

## all()
is_deeply( [ $arr->all ], [1, 2, 3], 'all() ok' );

## get()
cmp_ok( $arr->get(0), '==', 1, 'get 0 ok' );
cmp_ok( $arr->get(1), '==', 2, 'get 1 ok' );
cmp_ok( $arr->get(2), '==', 3, 'get 2 ok' );

## set()
ok( $arr->set(1, 4), 'set 1,4 ok' );
cmp_ok( $arr->get(1), '==', 4, 'get idx 1 after set 4 ok' );
ok( $arr->set(1, 2), 'set 1,2 ok' );
cmp_ok( $arr->get(1), '==', 2, 'get idx 1 after set 2 ok' );

## pop()
## push()
## shift()
## unshift()
## clear()
## delete()
## insert()
## map()
## grep()
## sort()
## reverse()
## sliced()
## splice()
## has_any()
## first
## firstidx
## reduce
## natatime
## items_after
## items_before
## shuffle
## uniq
## sort_by
## nsort_by
## uniq_by

done_testing;

