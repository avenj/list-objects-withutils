use Test::More;
use strict; use warnings FATAL => 'all';

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

{ package My::Autoboxen;
  use strict; use warnings FATAL => 'all';
  use List::Objects::WithUtils::Autobox
    HASH  => 'My::Hash::Obj',
    ARRAY => 'My::Array::Obj' ;

  use Test::More;

  ok []->foo, 'autoboxed array ok';
  ok {}->bar, 'autoboxed hash ok';

  my $foo = [1]->copy;
  ok $foo->isa('My::Array::Obj'), 'autoboxed array copy ok';

  my $bar = +{foo => 1}->copy;
  ok $bar->isa('My::Hash::Obj'), 'autoboxed hash copy ok';
}

done_testing;
