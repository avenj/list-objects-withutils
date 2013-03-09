package List::Objects::WithUtils::Role::Hash;

use Role::Tiny;
use Module::Runtime 'require_module';
use Scalar::Util 'blessed';

sub new {
  require_module( $self->_array_type );
  bless +{ @_[1 .. $#_] }, $_[0]
}

sub _array_type { 'List::Objects::WithUtils::Array' }

sub clear { %{ $_[0] } = () }

sub defined { CORE::defined $_[0]->{ $_[1] } }
sub exists  { CORE::exists  $_[0]->{ $_[1] } }

sub get {
  if (@_ > 2) {
    return $_[0]->_array_type->new(
      @{ $_[0] }{@_}
    )
  }
  $_[0]->{ $_[1] }
}

sub set {
  my $self = shift;
  my @keysidx = grep {; not $_ % 2 } 0 .. $#_ ;
  my @valsidx = grep {; $_ % 2 }     0 .. $#_ ;

  @{$self}{ @_[@keysidx] } = @_[@valsidx];

  $self->_array_type->new(
    @{$self}{ @_[@keysidx] }
  )
}

sub delete {
  $_[0]->_array_type->new(
    CORE::delete @{ $_[0] }{ @_ }
  )
}

sub keys {
  $_[0]->_array_type->new(
    CORE::keys %{ $_[0] }
  )
}

sub values {
  $_[0]->_array_type->new(
    CORE::values %{ $_[0] }
  )
}

sub kv {
  my ($self) = @_;
  $self->_array_type->new(
    CORE::map {;
      [ $_, $self->{ $_ } ]
    } CORE::keys %$self
  )
}

sub export {
  my ($self) = @_;
  CORE::map {; $_, $self->{$_} } CORE::keys %$self
}


1;
