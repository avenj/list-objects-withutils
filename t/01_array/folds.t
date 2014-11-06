use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

my $sum = sub { $_[0] + $_[1] };
my $arr = array(1 .. 3);

cmp_ok $arr->reduce($sum), '==', 6, 'reduce ok';
cmp_ok array(1)->reduce($sum), '==', 1, 'array with one element reduce ok';
ok !defined array->reduce($sum), 'empty array reduce ok';

cmp_ok array(6, 3, 2)->reduce(sub { $_[0] / $_[1] }), '==', 1,
  'reduce folds left';

cmp_ok array(6, 3, 2)->foldl(sub { $_[0] / $_[1] }), '==', 1,
  'foldl folds left';

cmp_ok array(6, 3, 2)->fold_left(sub { $_[0] / $_[1] }), '==', 1,
  'fold_left alias ok';

cmp_ok array(2, 3, 6)->foldr(sub { $_[1] / $_[0] }), '==', 1,
  'foldr folds right';

cmp_ok array(2, 3, 6)->fold_right(sub { $_[1] / $_[0] }), '==', 1,
  'fold_right alias ok';

ok !defined array->foldr($sum), 'empty array foldr ok';

done_testing;
