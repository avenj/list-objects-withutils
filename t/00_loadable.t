use Test::More;
use strict; use warnings FATAL => 'all';

BEGIN {
  use_ok( 'List::Objects::WithUtils' );
}

ok( main->can('array'), 'array() imported' );
ok( main->can('hash'),  'hash() imported'  );
ok( main->can('immarray'), 'immarray() imported' );

done_testing;
