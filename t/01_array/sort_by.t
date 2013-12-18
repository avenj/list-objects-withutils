# (also see utilsby_no_xs.t)
use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

if ($List::Objects::WithUtils::Role::Array::UsingUtilsByXS) {
  diag "Using List::UtilsBy::XS"
} else {
  diag "Using List::UtilsBy (XS not found)"
}

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

done_testing;
