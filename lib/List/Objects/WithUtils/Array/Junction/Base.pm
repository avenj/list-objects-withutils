package List::Objects::WithUtils::Array::Junction::Base;
use strictures 1;

use overload
    '=='   => 'num_eq',
    '!='   => 'num_ne',
    '>='   => 'num_ge',
    '>'    => 'num_gt',
    '<='   => 'num_le',
    '<'    => 'num_lt',
    'eq'   => 'str_eq',
    'ne'   => 'str_ne',
    'ge'   => 'str_ge',
    'gt'   => 'str_gt',
    'le'   => 'str_le',
    'lt'   => 'str_lt',
    'bool' => 'bool',
    '""'   => sub { shift },
;

sub new { bless [ @_[1 .. $#_] ], $_[0] }

1;
