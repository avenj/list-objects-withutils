package List::Objects::WithUtils::Array::Typed;
use strict; use warnings;
use Carp ();
use Scalar::Util ();

use parent 'List::Objects::WithUtils::Array';
no strict 'refs'; no warnings 'redefine';
local *List::Objects::WithUtils::Role::Array::blessed_or_pkg = sub {
    'List::Objects::WithUtils::Array'
};

use strictures 1;


use Exporter 'import';
our @EXPORT = 'array_of';
sub array_of { __PACKAGE__->new(@_) }

use overload
  '@{}'    => sub { shift->{array} },
  fallback => 1;


sub new {
  my $type = $_[1];
  Carp::confess "Expected a Type::Tiny type but got $type"
    unless Scalar::Util::blessed $type;
  my $self = +{
    type  => $type,
  };
  bless $self, $_[0];
  $self->{array} = [ map {; $self->_try_coerce($type, $_) } @_[2 .. $#_] ];
  $self
}

sub push {
  my $self = shift;
  $self->SUPER::push( 
    map {; $self->_try_coerce($self->{type}, $_) } @_
  )
}

sub unshift {
  my $self = shift;
  $self->SUPER::unshift(
    map {; $self->_try_coerce($self->{type}, $_) } @_
  )
}

sub set {
  my $self = shift;
  $self->SUPER::set( $_[0], $self->_try_coerce($self->{type}, $_[1]) )
}

1;

=pod


=cut
