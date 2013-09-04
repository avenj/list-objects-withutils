package List::Objects::WithUtils::Hash::Typed;
use strictures 1;

use parent 'List::Objects::WithUtils::Hash';

use Carp ();
use Scalar::Util ();

use Exporter 'import';
our @EXPORT = 'hash_of';
sub hash_of { __PACKAGE__->new(@_) }

sub type {
  tied(%{$_[0]})->type
}

sub new {
  my $class = shift;
  my $type;

  if (my $blessed = Scalar::Util::blessed $class) {
    $type  = $class->type;
    $class = $blessed;
  } else {
    $type = shift;
  }

  Carp::confess "Expected a Type::Tiny type but got '$type'"
    unless Scalar::Util::blessed($type)
    && $type->isa('Type::Tiny');

  require Type::Tie;
  my $self = {};
  tie(%$self, 'Type::Tie::HASH', $type);
  %$self = @_;
  bless $self, $class;
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

List::Objects::WithUtils::Hash::Typed - Type-checking hash objects

=head1 SYNOPSIS

  use List::Objects::WithUtils 'hash_of';

  use Types::Standard -all;
  use List::Objects::Types -all;

  my $arr = hash_of(Int, foo => 1, bar => 2);
  $arr->set(baz => 3.14159);    # dies, failed type check

=head1 DESCRIPTION

A L<List::Objects::WithUtils::Hash> subclass providing type-checking via
L<Type::Tiny> types.

This module requires L<Type::Tie>.

The first argument passed to the constructor should be a L<Type::Tiny> type:

  use Types::Standard -all;
  my $arr = hash_of ArrayRef() => (foo => [], bar => []);

Values are checked against the specified type when the object is constructed
or new elements are added.

If the initial type-check fails, a coercion is
attempted.

Values that cannot be coerced will throw an exception.

Also see L<Types::Standard>, L<List::Objects::Types>

It's worth noting that this comes with the obvious type-checking performance
hit, plus some extra overhead in proxying array operations.

=head2 type

Returns the L<Type::Tiny> type the object was created with.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>


=cut
