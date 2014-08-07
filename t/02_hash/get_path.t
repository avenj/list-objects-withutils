use Test::More;
use strict; use warnings FATAL => 'all';

use List::Objects::WithUtils 'hash';

my $hr = hash(
  scalar => 1,

  hash => +{
    a => 1,
    b => +{
      x => 10
    },
  },

  hashobj => hash(
    c => 2,
  ),
);

cmp_ok $hr->get_path('scalar'), '==', 1,
  'shallow get_path ok';

cmp_ok $hr->get_path(qw/hash b x/), '==', 10,
  'deep get_path ok';

cmp_ok $hr->get_path(qw/hashobj c/), '==', 2,
  'hash obj get_path ok';


done_testing
