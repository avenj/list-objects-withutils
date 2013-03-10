package List::Objects::WithUtils::Role::WithJunctions;
use strictures 1;
use Role::Tiny;

use Syntax::Keyword::Junction
  any => { -as => 'junction_any' },
  all => { -as => 'junction_all' };

sub any_items {
  junction_any( @{ $_[0] } )
}

sub all_items {
  junction_all( @{ $_[0] } )
}

1;

=pod

=head1 NAME

List::Objects::WithUtils::Role::WithJunctions - Arrays with junctions

=head1 SYNOPSIS

  use List::Objects::WithUtils 'array';

  my $array = array(qw/ a b c /);

  if ( $array->any_items eq 'b' ) {
    ...
  }

  if ( $array->all_items eq 'a' ) {
    ...
  }

=head1 DESCRIPTION

Used by L<List::Objects::WithUtils::Array> to provide access to
L<Syntax::Keyword::Junction>.

=head2 any_items

Returns the overloaded L<Syntax::Keyword::Junction/"any"> object for the
current array.

=head2 all_items

Returns the overloaded L<Syntax::Keyword::Junction/"all"> object for the
current array.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
