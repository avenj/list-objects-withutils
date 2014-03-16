package Lowu::Util;
use strict; use warnings FATAL => 'all';

sub uniq { my %s = (); grep {; not $s{$_}++ } @_ }


1;
