use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'hash';
my $hr = hash(map {; $_ => 1 } qw/d b c a/);

is_deeply
  [ $hr->kv_sort->all ],
  [
    [ a => 1 ],
    [ b => 1 ],
    [ c => 1 ],
    [ d => 1 ]
  ],
  'kv_sort default ok';

is_deeply
  [ $hr->kv_sort(sub { $_[1] cmp $_[0] })->all ],
  [
    [ d => 1 ],
    [ c => 1 ],
    [ b => 1 ],
    [ a => 1 ],
  ],
  'kv_sort with positional args ok';

is_deeply
  [ $hr->kv_sort(sub { $b cmp $a })->all ],
  [
    [ d => 1 ],
    [ c => 1 ],
    [ b => 1 ],
    [ a => 1 ],
  ],
  'kv_sort with named args ok';


done_testing;
