#!/usr/bin/env perl
use strict; use warnings;

use Lowu;

my $balls = array( 1 .. 59 )
  ->shuffle
  ->sliced( 1 .. 5 );

my $extra = array( 1 .. 35 )
  ->shuffle
  ->get(0);

print $balls->join('-'), ' ', $extra, "\n";
