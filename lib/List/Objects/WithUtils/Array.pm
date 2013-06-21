package List::Objects::WithUtils::Array;
use strictures 1;

require Role::Tiny;
Role::Tiny->apply_roles_to_package( __PACKAGE__,
  qw/
    List::Objects::WithUtils::Role::Array
    List::Objects::WithUtils::Role::WithJunctions
   /
);

use Exporter 'import';
our @EXPORT = 'array';
sub array { __PACKAGE__->new(@_) }

1;

=pod

=head1 NAME

List::Objects::WithUtils::Array - Array-type objects WithUtils

=head1 SYNOPSIS

  use List::Objects::WithUtils 'array';

  my $array = array(qw/ a b c /);

=head1 DESCRIPTION

See L<List::Objects::WithUtils::Role::Array> for a description of available
methods.

This class also consumes L<List::Objects::WithUtils::Role::WithJunctions>.

=head2 array

Creates a new array object.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Derived from L<Data::Perl> by Matt Phillips (CPAN: MATTP) et al

Licensed under the same terms as Perl

=cut
