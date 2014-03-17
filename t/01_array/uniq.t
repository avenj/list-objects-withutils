use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

if ($List::Objects::WithUtils::Role::Array::UsingMoreUtils) {
  diag "\nUsing List::MoreUtils\n";
}

my $arr = array( 1, 2, 2, 3, 4, 5, 5 );
my $uniq = $arr->uniq;
is_deeply
  [ $uniq->sort->all ],
  [ 1, 2, 3, 4, 5 ],
  'uniq ok';

$List::Objects::WithUtils::Role::Array::UsingMoreUtils = 0;
$uniq = $arr->uniq;
is_deeply
  [ $uniq->sort->all ],
  [ 1, 2, 3, 4, 5 ],
  'uniq ok (without MoreUtils)';

done_testing;
