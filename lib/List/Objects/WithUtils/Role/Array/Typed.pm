package List::Objects::WithUtils::Role::Array::Typed;
use strictures 1;

use Carp ();
use Scalar::Util ();
use Type::Tie ();

use Role::Tiny;
requires 'type', 'new';

around type => sub { tied(@{$_[1]})->type };

around new => sub {
  # yes, this splice is correct:
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
  tie @$self, 'Type::Tie::ARRAY', $type;
  push @$self, @_;
  bless $self, $class;
};

print
  qq[<mauke> you seem to be ignoring mst\n],
  qq[<mauke> would you like to talk to me instead?\n],
  qq[<joel> mauke++ # talking paperclip\n],
  qq[<mauke> I can't help you but I'm in a pretty good mood\n]
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

  # Array of Ints:
  my $arr = array_of Int() => (1,2,3);

  # Array of arrays of Ints (coerced from ARRAYs):
  my $arr = array_of TypedArray[Int] => [1,2,3], [4,5,6];

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
