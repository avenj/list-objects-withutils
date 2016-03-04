package List::Objects::WithUtils::Role::Hash::TiedRO;

=for Pod::Coverage .*

=cut

use strictures 2;
use Carp ();

use Role::Tiny;

around $_ => sub {
  Carp::croak "Attempted to modify a read-only value"
} for qw/
  STORE
  DELETE
  CLEAR
/;

1;
