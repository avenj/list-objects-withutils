#!/usr/bin/env perl

# An "almost-RPN-ish" calculator ...

use Lowu;

while (1) {
  print "Enter an expression (or 'q'uit):\n";
  my $expr = <STDIN>;
  my $stack = [];
  for my $item (split ' ', $expr) {
    if ($item eq 'q' || $item eq 'quit') {
      exit 0
    }

    if ($item eq 'p' || $item eq 'print') {
      print $stack->join(" "), "\n";
      next
    }

    if ($item =~ /\A[0-9]+\z/) {
      $stack->push($item);
      next
    }

    if ($item eq '+') {
      $stack = array( $stack->reduce(sub { shift() + shift() }) );
      next
    }
    if ($item eq '-') {
      $stack = array( $stack->reduce(sub { shift() - shift() }) );
      next
    }
    if ($item eq '*') {
      $stack = array( $stack->reduce(sub { shift() * shift() }) );
      next
    }
    if ($item eq '/') {
      $stack = array( $stack->reduce(sub { shift() / shift() }) );
      next
    }
  }

  print $stack->join(" "), "\n";
}
