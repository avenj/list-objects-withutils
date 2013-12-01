use Test::More;
use strict; use warnings FATAL => 'all';

require List::Objects::WithUtils;

eval {; List::Objects::WithUtils->import([]) };
like $@, qr/Expected a list of imports/i, 'bad import croaks ok';

done_testing;
