package List::Objects::WithUtils::Role::Array::Typed;
use strictures 1;

use Carp ();
use Scalar::Util ();
use Type::Tie ();

use Role::Tiny;
requires 'type', 'new';

around type => sub {
  shift;
  tied(@{$_[0]})->type
};

around new => sub {
  my (undef, $class, $type) = splice @_, 0, 2;

  if (my $blessed = Scalar::Util::blessed $class) {
    $type  = $class->type;
    $class = $blessed;
  } else {
    $type = shift;
  }

  Carp::confess "Expected a Type::Tiny type but got '$type'"
    unless Scalar::Util::blessed($type)
    && $type->isa('Type::Tiny');

  my $self = [];
  tie(@$self, 'Type::Tie::ARRAY', $type);
  push @$self, @_;
  bless $self, $class;
};

print
  qq[<Su-Shee> there are those days when I'm too stupid to loop over a],
  qq[ simple list of things... I should close my editor now.\n],
  qq[<dngor> Su-Shee: Hire an iterator. \n],
unless caller;
1;

=pod

=for Pod::Coverage new array_of

=head1 NAME

List::Objects::WithUtils::Role::Array::Typed - Type-checking array behavior

=head1 SYNOPSIS

  # Via List::Objects::WithUtils::Array::Typed ->
  use List::Objects::WithUtils 'array_of';
  use Types::Standard -all;
  use List::Objects::Types -all;

  my $arr_of_arrs = array_of( ArrayObj => [], [] );

=head1 DESCRIPTION

This role makes use of L<Type::Tie> to add type-checking behavior to
L<List::Objects::WithUtils::Role::Array> consumers.

The first argument passed to the constructor should be a L<Type::Tiny> type:

  use Types::Standard -all;
  my $arr = array_of Str() => qw/foo bar baz/;

Elements are checked against the specified type when the object is constructed
or new elements are added.

If the initial type-check fails, a coercion is attempted.

Values that cannot be coerced will throw an exception.

Also see L<Types::Standard>, L<List::Objects::Types>

=head2 type

Returns the L<Type::Tiny> type the object was created with.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org> with significant contributions from Toby
Inkster (CPAN: TOBYINK)

=cut
