package List::Objects::WithUtils::Autobox;
use strictures 1;

require List::Objects::WithUtils::Array;
require List::Objects::WithUtils::Hash;
require autobox;
our @ISA = 'autobox';
sub import {
  my ($class) = @_;
  $class->SUPER::import( ARRAY => 'List::Objects::WithUtils::Array' );
  $class->SUPER::import( HASH  => 'List::Objects::WithUtils::Hash'  );
}

1;
