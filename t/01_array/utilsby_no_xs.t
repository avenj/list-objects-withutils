use strict; use warnings FATAL => 'all';

BEGIN {
  unless (eval {; require Test::Without::Module; 1 } && !$@) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests require Test::Without::Module');
  }
}

use Test::More;
use List::Objects::WithUtils;

use Test::Without::Module 'List::UtilsBy::XS';

# sort_by
my $arr = array(
  +{ id => 'c' },
  +{ id => 'a' },
  +{ id => 'b' },
);

my $sorted = $arr->sort_by(sub { $_->{id} });

is_deeply
  [ $sorted->all ],
  [ +{ id => 'a' }, +{ id => 'b' }, +{ id => 'c' } ],
  'sort_by ok';

# nsort_by
$arr = array(
  +{ id => 2 },
  +{ id => 1 },
  +{ id => 3 },
);

$sorted = $arr->nsort_by(sub { $_->{id} });

is_deeply
  [ $sorted->all ],
  [ +{ id => 1 }, +{ id => 2 }, +{ id => 3 } ],
  'nsort_by ok';

# uniq_by
$arr = array(
  { id => 1 },
  { id => 2 },
  { id => 1 },
  { id => 3 },
  { id => 3 },
);
my $uniq = $arr->uniq_by(sub { $_->{id} });
is_deeply
  [ $uniq->all ],
  [
    { id => 1 },
    { id => 2 },
    { id => 3 },
  ],
  'uniq_by ok';

done_testing;

