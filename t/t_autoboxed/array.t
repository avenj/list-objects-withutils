use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'autobox';

cmp_ok []->count, '==', 0, 'empty autoboxed count() ok';
cmp_ok [1,2,3]->count, '==', 3, 'autoboxed count() ok';

cmp_ok [1,2,3]->join, 'eq', '1,2,3', 'autoboxed join() ok';
cmp_ok [1,2,3]->join('-'), 'eq', '1-2-3', 'autoboxed join(-) ok';

my $copy = [1,2,3]->copy;
cmp_ok $copy->count, '==', 3, 'autoboxed copy() ok';

ok []->is_empty, 'autoboxed is_empty ok';
ok !['foo']->is_empty, 'autoboxed !is_empty ok';

is_deeply [ [1,2,3]->all ], [1,2,3], 'autoboxed all() ok';

cmp_ok [1,2,3]->get(1), '==', 2, 'autoboxed get() ok';

my $foo = [1,2];
ok $foo->set(1, 4), 'autoboxed set() ok';
cmp_ok $foo->get(1), '==', 4, 'autoboxed get() after set() ok';

ok $foo->push(4, 5), 'autoboxed push() ok';
cmp_ok $foo->get(3), '==', 5, 'autoboxed get() after push() ok';

my $popped;
ok $popped = $foo->pop, 'autoboxed pop() ok';
cmp_ok $popped, '==', 5, 'popped value ok';

$foo = [1,2,3];

my $shifted;
ok $shifted = $foo->shift, 'autoboxed shift() ok';
cmp_ok $shifted, '==', 1, 'shifted value ok';

my $unshifted;
ok $unshifted = $foo->unshift($shifted), 'autoboxed unshift() ok';

$foo = [1,3,4];
ok $foo->insert(1, 2), 'autoboxed insert() ok';
is_deeply [ $foo->all ], [1,2,3,4], 'autoboxed all() after insert() ok';

my $deleted;
ok $deleted = $foo->delete(2), 'autoboxed delete() ok';
cmp_ok $deleted, '==', 3, 'deleted value ok';
is_deeply [ $foo->all ], [1,2,4], 'autoboxed all() after delete() ok';

$foo = [qw/ a b c /];

my $upper = $foo->map(sub { uc $_[0] });
isa_ok $upper, 'List::Objects::WithUtils::Array', 'autoboxed produced obj';
is_deeply [ $upper->all ], [qw/A B C/], 'autoboxed map() ok';

my $found = [qw/ a b c /]->grep(sub { $_[0] eq 'b' });
cmp_ok $found->count, '==', 1, 'autoboxed grep() ok';

$foo = [qw/ c b a /];
is_deeply [ $foo->sort->all ], [ qw/ a b c / ], 'autoboxed sort() ok';
is_deeply [ $foo->reverse->all ], [ qw/ a b c / ], 'autoboxed reverse() ok';
is_deeply [ $foo->sliced(0,2)->all ], [qw/ c a / ], 'autoboxed sliced() ok';

$foo = [qw/ a b c d /];
my $spliced = $foo->splice(1, 3);
is_deeply [ $spliced->all ], [ qw/ b c d/ ], '2-arg splice() ok';
$spliced->splice( 2, 1, 'e' );
is_deeply [ $spliced->all ], [ qw/ b c e/ ], '3-arg splice() ok';

ok ![]->has_any, 'autoboxed !has_any ok';
ok [1,2,3]->has_any, 'autoboxed has_any ok';
ok ![1,2,3]->has_any(sub { $_ eq 'foo' }), 'autoboxed !has_any with param ok';
ok [1,2,3]->has_any(sub { $_ == 2 }), 'autoboxed has_any with param ok';
cmp_ok [1,2,3]->first(sub { $_ == 2 }), '==', 2, 'autoboxed first() ok';
cmp_ok [1,2,3]->firstidx(sub { $_ == 2 }), '==', 1, 'autoboxed first_idx() ok';
cmp_ok [1,2,3]->reduce(sub { $_[0] + $_[1] }), '==', 6, 'autoboxed reduce() ok';

my $itr = [1 .. 7]->natatime(3);
is_deeply [ $itr->() ], [1,2,3], 'autoboxed natatime ok';

my $after = [1 .. 10]->items_after(sub { $_ == 5 });
is_deeply [ $after->all ], [6,7,8,9,10], 'autoboxed items_after ok';
$after = [1 .. 10]->items_after_incl(sub { $_ == 6 });
is_deeply [ $after->all ], [6,7,8,9,10], 'autoboxed items_after_incl ok';

my $before = [1 .. 10]->items_before(sub { $_ == 4 });
is_deeply [ $before->all ], [1,2,3], 'autoboxed items_before ok';
$before = [1 .. 10]->items_before_incl(sub { $_ == 4 });
is_deeply [ $before->all ], [1,2,3,4], 'autoboxed items_before_incl ok';

ok [1,2,3]->shuffle->count == 3, 'autoboxed shuffle() ok';
is_deeply [ [1,1,2,3,3]->uniq->sort->all ], [1,2,3], 'autoboxed uniq() ok';

my $sorted_hash = [ 
  { id => 'c' }, { id => 'a' }, { id => 'b' } 
]->sort_by(sub { $_->{id} });
is_deeply [ $sorted_hash->all ],
  [
    { id => 'a' }, { id => 'b' }, { id => 'c' }
  ],
  'autoboxed sort_by() ok';

ok [1,2,3]->any_items == 2, 'autoboxed junctions ok';

my $mesh_even = [qw/a b c d/]->mesh([1 .. 4]);
is_deeply [ $mesh_even->all ],
  [ a => 1, b => 2, c => 3, d => 4 ],
  'autoboxed mesh() ok';

my $parts_n = do { my $i = 0; [1 .. 12]->part(sub { $i++ % 3 }) };
ok $parts_n->count == 3, 'autoboxed part() ok';

my ($head, $tail) = [1,2,3]->head;
isa_ok $tail, 'List::Objects::WithUtils::Array', 'autoboxed head() produced obj';
my (undef, $rest) = [1,2,3]->tail;
isa_ok $rest, 'List::Objects::WithUtils::Array', 'autoboxed tail() produced obj';

{
  no List::Objects::WithUtils::Autobox;
  eval {; [1,2,3]->count };
  ok $@, 'lexical scoping seems ok';
}

done_testing;
