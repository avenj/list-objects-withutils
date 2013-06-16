use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'autobox';

ok +{}->is_empty, 'autoboxed is_empty() ok';
ok +{foo => 1}->exists('foo'), 'autoboxed exists() ok';
cmp_ok +{foo => 1}->get('foo'), '==', 1, 'autoboxed get() ok';
cmp_ok +{foo => 1}->copy->get('foo'), '==', 1, 'autoboxed copy() ok';

cmp_ok +{ foo => 1, bar => 2 }->keys->count, '==', 2, 
  'autoboxed keys() ok';
cmp_ok +{ foo => 1, bar => 2 }->values->count, '==', 2, 
  'autoboxed values() ok';

my $slice = +{ a => 1, b => 2, c => 3, d => 4 }->sliced('a', 'c');
isa_ok $slice, 'List::Objects::WithUtils::Hash', 'autoboxed slice() produced obj';
cmp_ok $slice->keys->count, '==', 2, 'autoboxed sliced() ok';

my $kv = +{ foo => 'bar', baz => 'quux' }->kv;
my @sorted = $kv->sort_by(sub { $_->[0] })->all;
is_deeply [@sorted], [ [ baz => 'quux' ], [ foo => 'bar' ] ],
  'autoboxed kv() ok';

my $foo = +{ foo => 'bar' };
ok $foo->set(foo => 'quux' ), 'autoboxed set() ok';
cmp_ok $foo->get('foo'), 'eq', 'quux', 'autoboxed get() after set() ok';
ok $foo->delete('foo'), 'autoboxed delete() ok';
ok !$foo->get('foo'), 'autoboxed delete() deleted item ok';

$foo = +{ foo => 'bar' };
$foo->clear;
ok $foo->is_empty, 'autoboxed is_empty after clear ok';

done_testing;
