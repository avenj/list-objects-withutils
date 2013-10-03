package List::Objects::WithUtils::Role::Array::TiedRO;
use strictures 1;

use Carp ();

use Role::Tiny;

around $_ => sub {
  Carp::croak "Attempted to modify a read-only value"
} for qw/
  STORE
  STORESIZE
  CLEAR
  PUSH
  POP
  SHIFT
  UNSHIFT
  EXTEND
/;

around SPLICE => sub {
  my ($orig, $self, $offset, $len, @list) = @_;
  if (@list) {
    Carp::croak "Attempted to modify a read-only value"
  }
  $self->$orig($offset, $len)
};

1;
