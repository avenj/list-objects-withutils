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

sub _mk_ro {
  ## Borrowed from Const::Fast
  my (undef, $skip_clone, $bless) = @_;
  if (
    (reftype $_[0] || '') eq 'ARRAY' 
    && ! blessed($_[0])
    && ! &Internals::SvREADONLY($_[0])
  ) {
    my $do_clone = !$skip_clone && &Internals::SvREFCNT($_[0]) > 1;
    $_[0] = dclone($_[0]) if $do_clone;
    bless $_[0], $bless if $bless;
    &Internals::SvREADONLY($_[0], 1);
    _mk_ro($_) for @{ $_[0] };
  }
  Internals::SvREADONLY($_[0], 1);
  $_[0]
}

sub new {
  my $self = [ @_[1 .. $#_] ];
#  bless $self, $_[0];
  _mk_ro($self, 1, $_[0])
#  $self
}

sub ___unimp {
  confess 'Method not implemented'
}

=pod

=begin Pod::Coverage

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
  *clear = *___unimp;
  *set   = *___unimp;
  *pop   = *___unimp;
  *push  = *___unimp;
  *shift = *___unimp;
  *unshift = *___unimp;
  *delete  = *___unimp;
  *insert  = *___unimp;
  *splice  = *___unimp;
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

The array is also marked read-only.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Licensed under the same terms as Perl

=cut
