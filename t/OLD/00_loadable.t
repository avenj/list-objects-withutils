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

{ package My::FuncsOnly;
  use Test::More;
  use strict; use warnings FATAL => 'all';

  use List::Objects::WithUtils ':functions';

  ok( My::FuncsOnly->can('array'), 'functions imported array()');
  ok( My::FuncsOnly->can('hash'),  'functions imported hash()' );
  ok( My::FuncsOnly->can('immarray'), 'functions imported immarray()' );
  ok( My::FuncsOnly->can('array_of'), 'functions imported array_of()' );
  ok( My::FuncsOnly->can('hash_of'),  'functions imported hash_of()'  );
  eval {; []->count };
  ok( $@, 'functions skipped autobox');
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

{ package My::Defaults;
  use strict; use warnings FATAL => 'all';

  use parent 'List::Objects::WithUtils';
  sub import {
    my ($class) = @_;
    $class->SUPER::import({
      import => [ 'autobox', 'immarray' ],
      to     => 'My::Target',
    })
  }
}
{
  package My::Target;
  use strict; use warnings FATAL => 'all';
  use Test::More;

  BEGIN { My::Defaults->import }
  ok( My::Target->can('immarray'), 'import immarray to target looks ok' );
  ok( !My::Target->can('array'), 'import omitted array ok' );
  cmp_ok( []->count, '==', 0, 'import autobox to target looks ok' );
}


{ package My::Array::Obj;
  use strict; use warnings FATAL => 'all';
  use parent 'List::Objects::WithUtils::Array';

  sub foo { 1 }
}
{ package My::Hash::Obj;
  use strict; use warnings FATAL => 'all';
  use parent 'List::Objects::WithUtils::Hash';

  sub bar { 1 }
}
{
  package My::Uses::List;
  use strict; use warnings FATAL => 'all';
  use List::Objects::WithUtils::Autobox
    HASH  => 'My::Hash::Obj',
    ARRAY => 'My::Array::Obj'
  ;

  use Test::More;

  ok( []->foo, 'imported autobox array with specified pkg ok' );
  ok( +{}->bar, 'imported autobox hash with specified pkg ok' );
  my $foo;
  ok( $foo = [1]->copy, 'imported autobox with specified pkg subclass ok' );
  my $bar;
  ok( $bar = +{foo => 'bar'}->copy, 'imported autobox hash with specified pkg subclass ok' );
}

done_testing;
