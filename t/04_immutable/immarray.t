use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils;

ok array->is_mutable, 'array is_mutable';
ok !immarray->is_mutable, 'immarray !is_mutable';
ok !array->is_immutable, 'array !is_immutable';
ok immarray->is_immutable, 'immarray is_immutable';

my $imm = immarray( 1 .. 4 );

for my $method
  (@List::Objects::WithUtils::Role::Array::Immutable::ImmutableMethods) {
  eval {; $imm->$method };
  ok $@ =~ /implemented/, "$method dies"
}

eval {; push @$imm, 'bar' };
ok $@ =~ /read-only/, 'push dies';

eval {; pop @$imm };
ok $@ =~ /read-only/, 'pop dies';

eval {; unshift @$imm, 0 };
ok $@ =~ /read-only/, 'unshift dies';

eval {; shift @$imm };
ok $@ =~ /read-only/, 'shift dies';

eval {; splice @$imm, 0, 1, 10 };
ok $@ =~ /read-only/, '3-arg splice dies';

eval {; $imm->[10] = 'foo' };
ok $@ =~ /read-only/, 'attempted extend dies';

eval {; $imm->[0] = 10 };
ok $@ =~ /read-only/, 'element set dies';

eval {; @$imm = () };
ok $@ =~ /read-only/, 'array clear dies';

is_deeply
  [ $imm->all ],
  [ 1 .. 4 ],
  'array ok after exceptions';

# Make sure we didn't recursively break anything:
my $with_arr = immarray( array( qw/ a b c / ) );
ok( $with_arr->get(0)->set(0, 'foo'), 'mutable set() inside immutable list ok');

my $with_hash = immarray( hash( foo => 'bar' ) );
ok( $with_hash->get(0)->get('foo') eq 'bar', 'hash in immarray ok' );
ok( $with_hash->get(0)->set(foo => 'baz'), 'hash->set in immarray ok' );
ok( $with_hash->get(0)->get('foo') eq 'baz', 'hash->get in immarray ok' );

done_testing;
