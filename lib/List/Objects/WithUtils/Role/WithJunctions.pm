package List::Objects::WithUtils::Role::WithJunctions;
use strictures 1;
use Role::Tiny;

use Syntax::Keyword::Junction
  any  => { -as => 'junction_any' },
  all  => { -as => 'junction_all' },
  none => { -as => 'junction_none' },
  ;

use namespace::clean;

sub any_items {
  junction_any( @{ $_[0] } )
}

sub all_items {
  junction_all( @{ $_[0] } )
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

  ## As a Role ->
  use Role::Tiny::With;
  with 'List::Objects::WithUtils::Role::Array',
       'List::Objects::WithUtils::Role::WithJunctions';

=head1 DESCRIPTION

Used by L<List::Objects::WithUtils::Array> to provide access to
L<Syntax::Keyword::Junction>.

=head2 any_items

Returns the overloaded L<Syntax::Keyword::Junction/"any"> object for the
current array.

=head2 all_items

Returns the L<Syntax::Keyword::Junction/"all"> object for the
current array.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
