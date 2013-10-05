use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils;

ok hash->is_mutable, 'hash is_mutable';
ok !immhash->is_mutable, 'immhash not is_mutable';

my $imm = immhash( foo => 1, bar => 2 );

for my $method
  (@List::Objects::WithUtils::Role::Hash::Immutable::ImmutableMethods) {
  local $@;
  eval {; $imm->$method };
  ok $@ =~ /implemented/, "$method dies"
}

eval {; $imm->{baz} = 'quux' };
ok $@, 'attempt to add key died' or diag explain $@;

eval {; $imm->{foo} = 2 };
ok $@, 'attempt to modify existing died';

eval {; delete $imm->{bar} };
ok $@, 'attempt to delete key died';

ok $imm->get('foo') == 1 && $imm->get('bar') == 2;

done_testing;
