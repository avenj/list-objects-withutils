use strict; use warnings;

use List::Objects::WithUtils;
use Benchmark 'cmpthese', 'timethese';

my $foreach = sub {
  my $array = array(1 .. 100_000);
  for ($array->all) {
    my $foo = $_ + 1
  }
  ()
};

my $visit = sub {
  my $array = array(1 .. 100_000);
  $array->visit(sub { my $foo = $_ + 1 });
  ()
};

my $results = timethese( 500 =>
  +{
      foreach => $foreach,
      visit   => $visit,
  }
);
cmpthese($results);
