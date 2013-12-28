use strict; use warnings;

use Types::Standard 'Num';

use List::Objects::WithUtils;
use Benchmark 'cmpthese', 'timethese';

my @values = ( 1 .. 100 );

my $basic = sub {
  my $arr = array @values
};

my $immutable = sub {
  my $arr = immarray @values
};

my $typed = sub {
  my $arr = array_of Num() => @values
};

my $typed_immutable = sub {
  my $arr = immarray_of Num() => @values
};

my $results = timethese( 200_000 =>
  +{
      array       => $basic,
      immarray    => $immutable,
      array_of    => $typed,
      immarray_of => $typed_immutable,
  }
);
cmpthese($results);
