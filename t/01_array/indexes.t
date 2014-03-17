use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'array';

if ($List::Objects::WithUtils::Role::Array::UsingMoreUtils) {
  diag "\nUsing List::MoreUtils\n"
}

ok !array->indexes(sub { 1 })->has_any, 'empty indexes ok';
my $arr = array(qw/foo bar baz/);
my $idx = $arr->indexes(sub { $_ eq 'bar' });
is_deeply [ $idx->all ], [ 1 ],
  'indexes (single) ok';
is_deeply [ $idx->all ], [ $arr->indices(sub { $_ eq 'bar' })->all ],
  'indices alias ok';

$arr = array( 1 .. 10 );
$idx = $arr->indexes(sub { $_ % 2 == 0 });
is_deeply [ $idx->all ], [ 1, 3, 5, 7, 9 ],
  'indexes (multiple) ok';

$List::Objects::WithUtils::Role::Array::UsingMoreUtils = 0;
$idx = $arr->indexes(sub { $_ % 2 == 0 });
is_deeply [ $idx->all ], [ 1, 3, 5, 7, 9 ],
  'indexes (without MoreUtils) ok';

done_testing
