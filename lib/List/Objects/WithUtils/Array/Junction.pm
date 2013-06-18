package List::Objects::WithUtils::Array::Junction;
use strictures 1;
use overload
    '=='   => 'num_eq',
    '!='   => 'num_ne',
    '>='   => 'num_ge',
    '>'    => 'num_gt',
    '<='   => 'num_le',
    '<'    => 'num_lt',
    'eq'   => 'str_eq',
    'ne'   => 'str_ne',
    'ge'   => 'str_ge',
    'gt'   => 'str_gt',
    'le'   => 'str_le',
    'lt'   => 'str_lt',
    'bool' => 'bool',
    '""'   => sub { shift },
;

sub new { bless [ @_[1 .. $#_] ], $_[0] }

1;

=pod

=for Pod::Coverage new

=head1 NAME

List::Objects::WithUtils::Array::Junction

=head1 SYNOPSIS

  # See List::Objects::WithUtils::Role::WithJunctions

=head1 DESCRIPTION

These are light-weight junction objects covering a subset of the functionality
provided by L<Syntax::Keyword::Junction>.

Only the junction types used by L<List::Objects::WithUtils> ('any' and 'all')
are implemented; nothing is exported. See L<Syntax::Keyword::Junction> if you
were looking for a stand-alone implementation.

See L<List::Objects::WithUtils::Role::WithJunctions> for usage details.

=head2 Motivation

My original goal was to get L<Sub::Exporter> out of the
L<List::Objects::WithUtils> dependency tree; that one came along with
L<Syntax::Keyword::Junction>.

L<Perl6::Junction> would have done that for me. Unfortunately, that comes with
some unresolved RT bugs right now that are reasonably annoying (especially
warnings under perl-5.18.x).

=head1 AUTHOR

This code is originally derived from L<Perl6::Junction> by way of
L<Syntax::Keyword::Junction>.

Slimmed down and adapted to L<List::Objects::WithUtils> by Jon Portnoy
<avenj@cobaltirc.org>
