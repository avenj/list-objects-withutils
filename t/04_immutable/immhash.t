use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils;

my $imm = immhash( foo => 1, bar => 2 );

for my $method
  (@List::Objects::WithUtils::Role::Hash::Immutable::ImmutableMethods) {
  local $@;
  eval {; $imm->$method };
  ok $@ =~ /implemented/, "$method dies"
}

{ local $@;
  eval {; $imm->{baz} = 'quux' };
  ok $@, 'attempt to add key died';
  eval {; $imm->{foo} = 2 };
  ok $@ =~ /read-only/, 'attempt to modify existing died';
}


done_testing;
