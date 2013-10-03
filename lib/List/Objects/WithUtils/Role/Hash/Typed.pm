package List::Objects::WithUtils::Role::Hash::Typed;
use strictures 1;

use Carp ();
use Scalar::Util ();
use Type::Tie ();

use Role::Tiny;
requires 'type', 'new';

around type => sub { tied(%{$_[1]})->type };

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

  my $self = {};
  tie(%$self, 'Type::Tie::HASH', $type);
  %$self = @_;
  bless $self, $class;
};

1;

=pod

=for Pod::Coverage new hash_of

=head1 NAME

List::Objects::WithUtils::Role::Hash::Typed - Type-checking hash behavior

=head1 SYNOPSIS

  # Via List::Objects::WithUtils::Hash::Typed ->
  use List::Objects::WithUtils 'hash_of';
  use Types::Standard -all;

  my $arr = hash_of(Int, foo => 1, bar => 2);
  $arr->set(baz => 3.14159);    # dies, failed type check

=head1 DESCRIPTION

This role makes use of L<Type::Tie> to add type-checking behavior to
L<List::Objects::WithUtils::Role::Hash> consumers.

The first argument passed to the constructor should be a L<Type::Tiny> type:

  use Types::Standard -all;
  my $arr = hash_of ArrayRef() => (foo => [], bar => []);

Values are checked against the specified type when the object is constructed
or new elements are added.

If the initial type-check fails, a coercion is attempted.

Values that cannot be coerced will throw an exception.

Also see L<Types::Standard>, L<List::Objects::Types>

=head2 type

Returns the L<Type::Tiny> type the object was created with.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>; typed hashes implemented by Toby Inkster
(CPAN: TOBYINK)

=cut
