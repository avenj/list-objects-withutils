package List::Objects::WithUtils::Hash::Inflated;
use strictures 1;
require Carp;

sub new {
  bless +{ @_[1 .. $#_] }, $_[0]
}

our $AUTOLOAD;
sub AUTOLOAD {
  my $self = shift || return;
  ( my $method = $AUTOLOAD ) =~ s/.*:://;
  
  Carp::confess "Can't locate object method '$method'"
    unless exists $self->{$method};
  Carp::confess "Accessor '$method' is read-only"
    if @_;
  $self->{$method}
}

sub DESTROY {}

1;

=pod

=for Pod::Coverage new AUTOLOAD

=cut
