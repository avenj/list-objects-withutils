#!/usr/bin/env perl
use strict; use warnings;
use Lowu;

my $selected = array;

while ($selected->count < 6) {

  if ($selected->count == 5) {
    print " > Selected balls: ", $selected->join('-'), "\n";
    my $eball;
    do { 
      print "Select an extra ball between 1 and 35: ";
      $eball = <STDIN>;
      chomp $eball;
    } until $eball and $eball > 0 and $eball < 35;

    $selected->push($eball);

    last
  }

  my $ball;
  do {
    my $current = $selected->count;
    print " > $current balls selected: ",
          $selected->join('-'), "\n";
    print "Select a ball between 1 and 59: ";
    $ball = <STDIN>;
    chomp $ball;
  } until $ball and $ball > 0 and $ball < 59;

  $selected->push($ball);
}

print " > You selected ", $selected->sliced(0 .. 4)->join('-'), "\n",
      " > Extra ball ".$selected->get(5), "\n";


my $balls = array( 1 .. 59 )
  ->shuffle
  ->sliced( 1 .. 5 );

my $extra = array( 1 .. 35 )
  ->shuffle
  ->get(0);

print "! Drew: ", $balls->join('-'), ' ', $extra, "\n";

my $hits = $selected->sliced(0 .. 4)->grep(sub {
  my $num = $_[0];
  $balls->has_any(sub { $_ == $num })
});

my $did_hit;

if ($hits->has_any) {
  print "!! You hit on ", $hits->count, " balls:\n";
  print "!!  ", $hits->join(', '), "\n";
  ++$did_hit
}

if ($selected->get(0) == $extra) {
  print "!! You hit on the extra ball ($extra)!\n";
  ++$did_hit
}

print " >> Better luck next time :(\n" unless $did_hit;
