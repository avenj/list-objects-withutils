package List::Objects::WithUtils::Array::Immutable::Typed;
use strictures 1;

{ package
    Lowu::Tied::Array::RO;
  use strictures 1;
  use Tie::Array ();
  use Carp ();
  our @ISA = 'Type::Tie::ARRAY';
  sub STORE {
    Carp::croak "Attempted to modify a read-only value"
  }
  { no warnings 'once';
    *CLEAR      = *STORE;
    *STORESIZE  = *STORE;
    *PUSH       = *STORE;
    *POP        = *STORE;
    *SHIFT      = *STORE;
    *UNSHIFT    = *STORE;
    *EXTEND     = *STORE;
  }
  sub SPLICE {
    my ($self, $offset, $len, @list) = @_;
    if (@list) {
      goto &STORE
    }
    $self->SUPER::SPLICE($offset, $len)
  }
}

require Role::Tiny;
Role::Tiny->apply_roles_to_package( __PACKAGE__,
  qw/
    List::Objects::WithUtils::Role::Array
    List::Objects::WithUtils::Role::Array::WithJunctions
    List::Objects::WithUtils::Role::Array::Typed
    List::Objects::WithUtils::Role::Array::Immutable
  /,
);

use Exporter 'import';
our @EXPORT = 'immarray_of';
sub immarray_of { 
  my $self = __PACKAGE__->new(@_);
  &Internals::SvREADONLY($self, 0);
  tie(@$self, 'Lowu::Tied::Array::RO', $self->type);
  warn "WTF3 ".$self->join('-');
  $self
}

1;

=pod

=for Pod::Coverage immarray_of

=head1 NAME

List::Objects::WithUtils::Array::Immutable::Typed - Immutable typed arrays

=head1 SYNOPSIS

  use List::Objects::WithUtils 'immarray_of';
  use Types::Standard -types;
  my $array = immarray_of( Int() => 1, 2, 3 );

=head1 DESCRIPTION

These are immutable type-checking array objects, essentially a combination of
L<List::Objects::WithUtils::Array::Typed> and
L<List::Objects::WithUtils::Array::Immutable>.

This class consumes the following roles, which contain most of the relevant
documentation:

L<List::Objects::WithUtils::Role::Array>

L<List::Objects::WithUtils::Role::Array::WithJunctions>

L<List::Objects::WithUtils::Role::Array::Typed>

L<List::Objects::WithUtils::Role::Array::Immutable>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
