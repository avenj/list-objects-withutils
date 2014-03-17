use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

if ($List::Objects::WithUtils::Role::Array::UsingMoreUtils) {
  diag "\nUsing List::MoreUtils\n"
}

my $arr = array( 1 .. 7 );
my $after = $arr->items_after(sub { $_ == 3 });
is_deeply
  [ $after->all ],
  [ 4 .. 7 ],
  'items_after ok';

$List::Objects::WithUtils::Role::Array::UsingMoreUtils = 0;
$after = $arr->items_after(sub { $_ == 3 });
is_deeply
  [ $after->all ],
  [ 4 .. 7 ],
  'items_after (without MoreUtils) ok';

done_testing;
