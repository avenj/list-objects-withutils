
BEGIN {
  unless (
    eval {; require List::Objects::Types; 1 } && !$@
    && eval {; require Types::Standard; 1 }   && !$@
  ) {
    require Test::More;
    Test::More::plan(skip_all =>
      'these tests require List::Objects::Types and Types::Standard'
    );
  }
}

use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::Types -all;
use Types::Standard -all;

use List::Objects::WithUtils 'array';

my $arr = array(qw/ foo bar baz quux/);
my $valid = $arr->validated(Str);
is_deeply
  [ $valid->all ],
  [ qw/ foo bar baz quux / ],
  'validated(Str) returned array ok';

eval {; $valid = $arr->validated(Int) };
ok $@ =~ /type/i, 'validated(Int) failed with type error'
  or diag explain $@;

done_testing;
