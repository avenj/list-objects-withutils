use Test::More;

use List::Objects::WithUtils::Autobox;

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



done_testing;
