package List::Objects::WithUtils::Array::Immutable;
use strictures 1;
use Carp 'confess';

use Role::Tiny::With;
require List::Objects::WithUtils::Array;

our @ISA = 'List::Objects::WithUtils::Array';

use Exporter 'import';
our @EXPORT = 'immarray';
sub immarray { __PACKAGE__->new(@_) }

use Scalar::Util 'reftype', 'blessed';
use Storable 'dclone';

sub __mk_ro {
  ## Inspired by Const::Fast ->
  my (undef, $skip_clone, $bless) = @_;
  if (
    (reftype $_[0] || '') eq 'ARRAY' 
    && ! blessed($_[0])
    && ! &Internals::SvREADONLY($_[0])
  ) {
    my $do_clone = !$skip_clone && &Internals::SvREFCNT($_[0]) > 1;
    $_[0] = dclone($_[0]) if $do_clone;
    bless($_[0], $bless) if $bless;
    &Internals::SvREADONLY($_[0], 1);
    __mk_ro($_) for @{ $_[0] };
  }
  Internals::SvREADONLY($_[0], 1);
  $_[0]
}

sub new { __mk_ro([ @_[1 .. $#_] ], 1, $_[0]) }

sub __unimp {
  confess 'Method not implemented'
}

=pod

=begin Pod::Coverage

new
immarray
clear
set
pop
push
shift 
unshift 
delete 
insert 
splice

=end Pod::Coverage

=cut

{ no warnings 'once';
  *clear = *__unimp;
  *set   = *__unimp;
  *pop   = *__unimp;
  *push  = *__unimp;
  *shift = *__unimp;
  *unshift = *__unimp;
  *delete  = *__unimp;
  *insert  = *__unimp;
  *splice  = *__unimp;
}

1;

=pod

=head1 NAME

List::Objects::WithUtils::Array::Immutable - Immutable array objects

=head1 SYNOPSIS

  use List::Objects::WithUtils 'immarray';

  my $array = immarray(qw/ a b c /);

  my ($head, $rest) = $array->head;

=head1 DESCRIPTION

A subclass of L<List::Objects::WithUtils::Array> without the following
list-mutating methods:

  clear
  set
  pop push
  shift unshift
  delete
  insert
  splice

The array is marked read-only; attempting to call the methods listed above or
manually modify the backing ARRAY reference will throw an exception.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Licensed under the same terms as Perl.

=cut
