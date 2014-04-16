use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $sum = sub { $_[0] + $_[1] };
my $arr = array(1 .. 3);

cmp_ok $arr->reduce($sum), '==', 6, 'reduce ok';
cmp_ok array(1)->reduce($sum), '==', 1, 'array with one element reduce ok';
ok !defined array->reduce($sum), 'empty array reduce ok';

done_testing;
