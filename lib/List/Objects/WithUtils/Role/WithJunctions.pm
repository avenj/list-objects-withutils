package List::Objects::WithUtils::Role::WithJunctions;
use strictures 1;
use Role::Tiny;

require List::Objects::WithUtils::Array::Junction::Any;
require List::Objects::WithUtils::Array::Junction::All;

sub any_items {
  List::Objects::WithUtils::Array::Junction::Any->new( @{ $_[0] } )
}

sub all_items {
  List::Objects::WithUtils::Array::Junction::All->new( @{ $_[0] } )
}

1;

=pod

=head1 NAME

List::Objects::WithUtils::Role::WithJunctions - Add junctions to Arrays

=head1 SYNOPSIS

  ## Via List::Objects::WithUtils::Array ->
  use List::Objects::WithUtils 'array';

  my $array = array(qw/ a b c /);

  if ( $array->any_items eq 'b' ) {
    ...
  }

  if ( $array->all_items eq 'a' ) {
    ...
  }

  if ( $array->any_items == qr/^b/ ) {
    ...
  }

  ## As a Role ->
  use Role::Tiny::With;
  with 'List::Objects::WithUtils::Role::Array',
       'List::Objects::WithUtils::Role::WithJunctions';

=head1 DESCRIPTION

These methods supply overloaded L<List::Objects::WithUtils::Array::Junction>
objects that can be compared with values using normal Perl comparison
operators.

Regular expressions can be matched by providing a C<qr//> regular expression
object to the C<==> or C<!=> operators.

=head2 any_items

Returns the overloaded B<any> object for the current array; a comparison is
true if any items in the array satisfy the condition.

=head2 all_items

Returns the overloaded B<all> object for the current array; a comparison is
true only if all items in the array satisfy the condition.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
