
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


done_testing;
