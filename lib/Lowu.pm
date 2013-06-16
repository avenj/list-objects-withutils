package Lowu;
use strictures 1;

use parent 'List::Objects::WithUtils';

sub import {
  my ($class, @funcs) = @_;
  @funcs = 'all' unless @funcs;
  $class->SUPER::import(
    +{
      import  => [ @funcs ],
      to      => scalar(caller),
    }
  )
}

print
 qq[I'm not sorry, on account of all the typing I've saved myself ;-)\n]
unless caller;
1;

=pod

=for Pod::Coverage import

=head1 NAME

Lowu - Shortcut for importing list object goodness

=head1 SYNOPSIS

  # Same as:
  #  use List::Objects::WithUtils ':all';
  use Lowu;

=head1 DESCRIPTION

A short-to-type way to get all of List::Objects::WithUtils, including
autoboxing.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
