use strict; use warnings;
use Lowu;
use Data::Dumper;

print Dumper 
  [foo => 'bar', baz => 'quux']
    ->tuples
    ->map(sub { hash(@$_)->inflate })
