package List::Objects::WithUtils::Role::Array::Immutable;
use strictures 1;
use Carp ();

sub _make_unimp {
  my ($method) = @_;
  sub {
    local $Carp::CarpLevel = 1;
    Carp::croak "Method '$method' not implemented on immutable arrays"
  }
}

use Role::Tiny;

around new => sub {
  my $orig = shift;
  my $self = $orig->(@_);

  &Internals::SvREADONLY($self, 1);
  Internals::SvREADONLY($_, 1) for @$self;

  $self
};

my $unimp = sub {
  local $Carp::CarpLevel = 1;
  Carp::croak 'Method not implemented on immutable arrays'
};

around $_ => _make_unimp($_) for qw/
  clear
  set
  pop push
  shift unshift
  delete delete_when
  insert
  splice
/;

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
delete_when
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
  delete delete_when
  insert
  splice

The array is marked read-only; attempting to call the methods listed above or
manually modify the backing ARRAY reference will throw an exception.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Licensed under the same terms as Perl.

=cut
