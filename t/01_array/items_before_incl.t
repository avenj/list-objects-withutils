use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

if ($List::Objects::WithUtils::Role::Array::UsingMoreUtils) {
  diag "\nUsing List::MoreUtils\n"
}

my $arr = array( 1 .. 7 );
my $before = $arr->items_before_incl(sub { $_ == 4 });
is_deeply
  [ $before->all ],
  [ 1 .. 4 ],
  'items_before_incl ok';

$List::Objects::WithUtils::Role::Array::UsingMoreUtils = 0;
$before = $arr->items_before_incl(sub { $_ == 4 });
is_deeply
  [ $before->all ],
  [ 1 .. 4 ],
  'items_before_incl (without MoreUtils) ok';

done_testing;
