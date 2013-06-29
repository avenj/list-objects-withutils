#!/usr/bin/env perl
use strict; use warnings;
use 5.10.1;
use Lowu;

my $search = immarray(
  +{ name => 'bob', id => '200' },
  +{ name => 'joe', id => '400' },
  +{ name => 'sam', id => '600' },
  +{ name => 'amy', id => '800' },
)->first(sub {
  $_->{id} > 500
}) or die 'No employees with ID > 500';

my $person = $search->inflate;
say "Employee ".ucfirst($person->name)." has ID ".$person->id;
