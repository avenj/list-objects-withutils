package List::Objects::WithUtils::Array::Immutable;
use strictures 1;
use Carp 'confess';

use Role::Tiny::With;
require List::Objects::WithUtils::Array;

our @ISA = 'List::Objects::WithUtils::Array';

use Exporter 'import';
our @EXPORT = 'valarray';
sub valarray { __PACKAGE__->new(@_) }

sub ___unimp {
  confess 'Method not implemented'
}

=pod

=begin Pod::Coverage

valarray
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

  use List::Objects::WithUtils 'valarray';

  my $array = valarray(qw/ a b c /);

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

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Licensed under the same terms as Perl

=cut
