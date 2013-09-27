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

my $immh = immhash_of Int() => ( foo => 1, bar => 2 );

ok $immh->type == Int, 'type ok';

eval {; immhash_of Int() => ( foo => 'baz' ) };
ok $@ =~ /constraint/, 'immhash_of invalid type died';

for my $method
  (@List::Objects::WithUtils::Role::Hash::Immutable::ImmutableMethods) {
  local $@;
  eval {; $immh->$method };
  ok $@ =~ /implemented/, "$method dies"
}

done_testing;
