package List::Objects::WithUtils::Hash::Inflated::RW;
use strictures 1;

use parent 'List::Objects::WithUtils::Hash::Inflated';

our $AUTOLOAD;
sub AUTOLOAD {
  my $self = shift || return;
  ( my $method = $AUTOLOAD ) =~ s/.*:://;

  Carp::confess "Can't locate object method '$method'"
    unless exists $self->{$method};
  return $self->{$method} unless @_;
  Carp::confess "Multiple arguments passed to setter '$method'"
    if @_ > 1;
  $self->{$method} = $_[0]
}

1;

=pod

=for Pod::Coverage AUTOLOAD

=cut
