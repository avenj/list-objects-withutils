package List::Objects::WithUtils::Array;
use strictures 1;

use Role::Tiny::With;
with 'List::Objects::WithUtils::Role::Array',
     'List::Objects::WithUtils::Role::WithJunctions';

use Exporter 'import';
our @EXPORT = 'array';
sub array { __PACKAGE__->new(@_) }

1;

=pod

=head1 NAME

List::Objects::WithUtils::Array - An array container class

=head1 SYNOPSIS

  use List::Objects::WithUtils 'array';

  my $array = array(qw/ a b c /);

See L<List::Objects::WithUtils::Role::Array> for a description of available
methods.

=head1 DESCRIPTION

This class is a concrete implementation of
L<List::Objects::WithUtils::Role::Array>. Methods are documented there.

=head2 array

Creates a new array container object.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Derived from L<Data::Perl> by Matt Phillips (CPAN: MATTP) et al

Licensed under the same terms as Perl

=cut
