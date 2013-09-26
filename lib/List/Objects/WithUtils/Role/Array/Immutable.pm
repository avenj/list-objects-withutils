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

List::Objects::WithUtils::Role::Array::Immutable - Immutable array behavior

=head1 SYNOPSIS

  # Via List::Objects::WithUtils::Array::Immutable ->
  use List::Objects::WithUtils 'immarray';
  my $array = immarray(qw/ a b c /);

=head1 DESCRIPTION

This role adds immutable behavior to L<List::Objects::WithUtils::Role::Array>
consumers.

The following methods are not available and will throw an exception:

  clear
  set
  pop push
  shift unshift
  delete delete_when
  insert
  splice

See L<List::Objects::WithUtils::Array::Immutable> for a consumer
implementation that also pulls in L<List::Objects::WithUtils::Role::Array> &
L<List::Objects::WithUtils::Role::Array::WithJunctions>.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Licensed under the same terms as Perl.

=cut
