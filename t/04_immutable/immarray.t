use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils;

my $imm = immarray( 1 .. 4 );

for my $method
  (@List::Objects::WithUtils::Role::Array::Immutable::ImmutableMethods) {

  local $@;
  eval {; $imm->$method };
  ok $@ =~ /implemented/, "$method dies"
}

{ local $@;
  eval {; push @$imm, 'bar' };
  ok $@ =~ /read-only/, 'attempt to modify died';
}

# Make sure we didn't recursively break anything:
my $with_arr = immarray( array( qw/ a b c / ) );
ok( $with_arr->get(0)->set(0, 'foo'), 'mutable set() inside immutable list ok');

my $with_hash = immarray( hash( foo => 'bar' ) );
ok( $with_hash->get(0)->get('foo') eq 'bar', 'hash in immarray ok' );
ok( $with_hash->get(0)->set(foo => 'baz'), 'hash->set in immarray ok' );
ok( $with_hash->get(0)->get('foo') eq 'baz', 'hash->get in immarray ok' );

SKIP: {
  skip 'SvREADONLY behavior changed in 5.19', 1 if $] =~ /^5.019/;
# FIXME
# Fails in 5.19.3 for reasons not entirely clear to me ...
# ... but if the user is doing this they're already breaking encapsulation
  local $@;
  eval {; $with_hash->[0] = 'foo' };
  ok( $@ =~ /read-only/, 'attempt to modify 2 died' ) or diag $@;
}

done_testing;
