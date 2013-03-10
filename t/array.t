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
my $set;
ok( $set = $arr->set(1, 2), 'set 1,2 ok' );
ok( $set == $arr, 'set returned self' );
cmp_ok( $arr->get(1), '==', 2, 'get idx 1 after set 2 ok' );

undef $set;


## push()
ok( $arr->push(4, 5), 'push 4,5 ok' );
cmp_ok( $arr->get(4), '==', 5, 'get idx 4 after push ok' );
my $pushed;
ok( $pushed = $arr->push(6), 'push 6 ok' );
ok( $pushed == $arr, 'push returned self' );
is_deeply( [ $arr->all ], [1,2,3,4,5,6], 'all() after push ok' );

## pop()
my $popped;
ok( $popped = $arr->pop, 'pop ok' );
cmp_ok( $popped, '==', 6, 'popped value ok' );
is_deeply( [ $arr->all ], [1,2,3,4,5], 'all() after pop ok' );

undef $pushed;
undef $popped;


## shift()
my $shifted;
ok( $shifted = $arr->shift, 'shift ok' );
cmp_ok( $shifted, '==', 1, 'shifted value ok' );
is_deeply( [ $arr->all ], [2,3,4,5], 'all() after shift ok' );

## unshift()
my $unshifted;
ok( $unshifted = $arr->unshift($shifted), 'unshift ok' );
ok( $unshifted == $arr, 'unshift returned self' );
is_deeply( [ $arr->all ], [1,2,3,4,5], 'all() after unshift ok' );

## clear()
my $cleared;
ok( $cleared = $arr->clear, 'clear() ok' );
ok( $cleared == $arr, 'clear() returned self' );
ok( $arr->is_empty, 'array is_empty after clear' );

undef $shifted;
undef $unshifted;
undef $cleared;


$arr = array(1,3,4);
is_deeply( [ $arr->all ], [1,3,4], 'array reset' );

## insert()
my $inserted;
ok( $inserted = $arr->insert(1, 2), 'insert() ok' );
is_deeply( [ $arr->all ], [1,2,3,4], 'all() after insert() ok' );
ok( $inserted == $arr, 'insert returned self' );

## delete()
my $deleted;
ok( $deleted = $arr->delete(2), 'delete() ok' );
cmp_ok( $deleted, '==', 3, 'deleted value ok' );
is_deeply( [ $arr->all ], [1,2,4], 'all() after delete() ok' );

undef $inserted;
undef $deleted;
undef $arr;


$arr = array(qw/a b c/);
is_deeply( [ $arr->all ], [qw/a b c/], 'array reset' );

## map()
my $upper = $arr->map(sub { uc $_[0] });
is_deeply( [ $upper->all ], [qw/A B C/], 'map() ok' );
is_deeply( [ $arr->all ], [qw/a b c/], 'orig after map() ok' );

## grep()
$arr->push('b');
my $found = $arr->grep(sub { $_[0] eq 'b' });
is_deeply( [ $found->all ], [qw/b b/], 'grep() ok' );
is_deeply( [ $arr->all ], [qw/a b c b/], 'orig after grep() ok' );

undef $upper;
undef $found;

$arr = array(4, 2, 3, 1);

## sort()
my $sorted = $arr->sort(sub { $_[0] <=> $_[1] });
my $lazysorted = $arr->sort;
is_deeply( [ $sorted->all ], [1,2,3,4], 'sort() ok' );
is_deeply( [ $lazysorted->all ], [ $sorted->all ], 'default sort() ok' );

undef $sorted;
undef $lazysorted;


## reverse()
$arr = array(1,2,3);
my $reverse;
ok( $reverse = $arr->reverse, 'reverse() ok' );
is_deeply( [ $reverse->all ], [3,2,1], 'all() after reverse() ok' );
is_deeply( [ $arr->all ], [1,2,3], 'orig after reverse() ok' );

undef $reverse;

## sliced()
my $sliced;
ok( $sliced = $arr->sliced(0,2), 'sliced() ok' );
is_deeply( [ $sliced->all ], [1,3], 'all() after sliced() ok' );

undef $sliced;

## splice()
# FIXME

## has_any()
$arr = array();
ok( !$arr->has_any, 'negative has_any ok' );
$arr = array(qw/ a b c /);
ok( $arr->has_any, 'has_any ok' );
ok( $arr->has_any(sub { $_ eq 'b' }), 'has_any with param ok');
ok( !$arr->has_any(sub { $_ eq 'd' }), 'negative has_any with param ok' );

## first()
$arr = array(qw/ a ba bb c /);
my $first;
ok( $first = $arr->first(sub { $_ =~ /^b/ }), 'first() ok' );
cmp_ok( $first, 'eq', 'ba', 'first() correct element ok' );

## firstidx()
ok( $first = $arr->firstidx(sub { $_ =~ /^b/ }), 'firstidx() ok' );
cmp_ok( $first, '==', 1, 'firstidx() correct index ok' );

## reduce()
# FIXME

## natatime()
$arr = array(1 .. 7);
my $itr = $arr->natatime(3);
is_deeply( [ $itr->() ], [1,2,3], 'itr() 1 ok' );
is_deeply( [ $itr->() ], [4,5,6], 'itr() 2 ok' );
is_deeply( [ $itr->() ], [7], 'itr() 3 ok' );

undef $itr;

## items_after()
# FIXME
## items_before()
# FIXME
## shuffle()
# FIXME

## uniq()
$arr = array( 1, 2, 2, 3, 4, 5, 5 );
my $uniq = $arr->uniq;
is_deeply( [ $uniq->sort->all ], [1,2,3,4,5], 'uniq() ok' );

## sort_by()
# FIXME
## nsort_by()
# FIXME
## uniq_by()
# FIXME

done_testing;

