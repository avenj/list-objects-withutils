BEGIN {
  unless (eval {; require Types::Standard; 1 } && !$@) {
    require Test::More;
    Test::More::plan(skip_all =>
      'these tests require Types::Standard'
    );
  }
}


use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils;
use Types::Standard -all;

my $immof = immarray_of Int() => 1 .. 5;

ok $immof->type == Int, 'type ok';


eval {; immarray_of Int() => qw/foo 1 2/ };
ok $@ =~ /constraint/, 'immarray_of invalid type died';

for my $method
  (@List::Objects::WithUtils::Role::Array::Immutable::ImmutableMethods) {
  
  local $@;
  eval {; $immof->$method };
  ok $@ =~ /implemented/, "$method dies"
}

done_testing;
