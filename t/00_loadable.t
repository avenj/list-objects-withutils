use Test::More;
use strict; use warnings FATAL => 'all';

BEGIN {
  use_ok( 'List::Objects::WithUtils' );
}

ok( main->can('array'), 'array() imported' );
ok( main->can('hash'),  'hash() imported'  );
ok( main->can('immarray'), 'immarray() imported' );

{ package My::Foo;
  use Test::More;
  use strict; use warnings FATAL => 'all';

  use List::Objects::WithUtils ':all';

  ok( My::Foo->can('array'), 'all imported array()');
  ok( My::Foo->can('hash'),  'all imported hash()');
  ok( My::Foo->can('immarray'), 'all imported immarray()');
  cmp_ok( []->count, '==', 0, 'all imported autobox');
}

{ package My::Bar;
  use Test::More;
  use strict; use warnings FATAL => 'all';

  use Lowu;

  ok( My::Bar->can('array'), 'Lowu imported array()');
  ok( My::Bar->can('hash'),  'Lowu imported hash()');
  ok( My::Bar->can('immarray'), 'Lowu imported immarray()');
  cmp_ok( []->count, '==', 0, 'Lowu imported autobox');
}

done_testing;
