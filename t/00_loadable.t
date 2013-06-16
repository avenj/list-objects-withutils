use Test::More;
use strict; use warnings FATAL => 'all';

{ package My::Baz;
  use Test::More;
  use strict; use warnings FATAL => 'all';

  use List::Objects::WithUtils;

  ok( My::Baz->can('array'), 'array() imported' );
  ok( My::Baz->can('hash'),  'hash() imported'  );
  ok( My::Baz->can('immarray'), 'immarray() imported' );
}

{ package My::Quux;
  use Test::More;
  use strict; use warnings FATAL => 'all';

  use List::Objects::WithUtils 'array', 'hash';

  ok( My::Quux->can('array'), 'selectively imported array()' );
  ok( My::Quux->can('hash'),  'selectively imported hash()'  );
}


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
