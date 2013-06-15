package List::Objects::WithUtils::Array::Immutable;
use strictures 1;
use Carp 'croak';

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


sub __unimp { 
  local $Carp::CarpLevel = 1;
  croak 'Method not implemented on immutable arrays'
}
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

print
 qq[<LeoNerd> Coroutines are not magic pixiedust\n],
 qq[<DrForr> LeoNerd: Any sufficiently advanced technology.\n],
 qq[<LeoNerd> DrForr: ... probably corrupts the C stack during XS calls? ;)\n],
unless caller;
1;

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
