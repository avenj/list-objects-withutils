package List::Objects::WithUtils::Array::Typed;
use strictures 1;

use parent 'List::Objects::WithUtils::Array';

use Carp ();
use Scalar::Util ();

use Exporter 'import';
our @EXPORT = 'array_of';
sub array_of { __PACKAGE__->new(@_) }

use overload
  '@{}'    => sub { $_[0]->{array} },
  fallback => 1;


sub new {
  my $class = shift;
  my $type;

  if (my $blessed = Scalar::Util::blessed $class) {
    $type  = $class->{type};
    $class = $blessed;
  } else {
    $type = shift;
  }

  Carp::confess "Expected a Type::Tiny type but got '$type'"
    unless Scalar::Util::blessed($type)
    && $type->isa('Type::Tiny');

  my $self = +{
    type  => $type,
  };
  bless $self, $class;

  $self->{array} = [ map {; $self->_try_coerce($type, $_) } @_ ];

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

sub insert {
  my $self = shift;
  $self->SUPER::insert( $_[0], $self->_try_coerce($self->{type}, $_[1]) )
}

sub splice {
  my ($self, $one, $two) = splice @_, 0, 3;
  $self->SUPER::splice(
    $one, $two,
    ( @_ ? 
      map {; $self->_try_coerce($self->{type}, $_) } @_
      : ()
    ),
  )
}

print
  qq[<Su-Shee> there are those days when I'm too stupid to loop over a],
  qq[ simple list of things... I should close my editor now.\n],
  qq[<dngor> Su-Shee: Hire an iterator. \n],
unless caller;
1;

=pod

=for Pod::Coverage new push unshift set insert splice array_of

=head1 NAME

List::Objects::WithUtils::Array::Typed - Type-checking array objects

=head1 SYNOPSIS

  use List::Objects::WithUtils 'array_of';

  use Types::Standard -all;
  use List::Objects::Types -all;

  my $arr = array_of( Int() => 1 .. 10 );
  $arr->push('foo');  # dies

  my $arr_of_arrs = array_of( ArrayObj );
  $arr_of_arrs->push([], []);     # coerces to ArrayObj

=head1 DESCRIPTION

A L<List::Objects::WithUtils::Array> subclass providing type-checking via
L<Type::Tiny> types.

The first argument passed to the constructor should be a L<Type::Tiny> type:

  use Types::Standard -all;
  my $arr = array_of Str() => qw/foo bar baz/;

Elements are checked against the specified type when the object is constructed
or new elements are added.

If the initial type-check fails, a coercion is
attempted.

Values that cannot be coerced will throw an exception.

Also see L<Types::Standard>, L<List::Objects::Types>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>


=cut
