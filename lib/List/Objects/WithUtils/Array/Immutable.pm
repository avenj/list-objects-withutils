package List::Objects::WithUtils::Array::Immutable;
use strictures 1;
use Carp 'confess';

require List::Objects::WithUtils::Array;
our @ISA = 'List::Objects::WithUtils::Array';

use Exporter 'import';
our @EXPORT = 'immarray';
sub immarray { __PACKAGE__->new(@_) }

use Scalar::Util 'blessed';
use Storable 'dclone';

sub new {
  my $self = [ @_[1 .. $#_] ];
  bless $self, $_[0];

  &Internals::SvREADONLY($self, 1);
  Internals::SvREADONLY($_, 1) for @$self;

  $self
}

sub __unimp { confess 'Method not implemented' }

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
