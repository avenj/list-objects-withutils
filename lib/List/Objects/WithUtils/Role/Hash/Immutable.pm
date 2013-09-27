package List::Objects::WithUtils::Role::Hash::Immutable;
use strictures 1;
use Carp ();

sub _make_unimp {
  my ($method) = @_;
  sub {
    local $Carp::CarpLevel = 1;
    Carp::croak "Method '$method' not implemented on immutable hashes"
  }
}

our @ImmutableMethods = qw/
  clear
  set
  delete
/;

use Role::Tiny;
requires 'new', @ImmutableMethods;

around new => sub {
  my $orig = shift;
  my $self = $orig->(@_);

  &Internals::SvREADONLY($self, 1);
  Internals::SvREADONLY($_, 1) for values %$self;

  $self
};

around $_ => _make_unimp($_) for @ImmutableMethods;

1;
