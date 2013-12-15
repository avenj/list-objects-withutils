#!/usr/bin/env perl
use strict; use warnings;
use Lowu;
STDOUT->autoflush(1);

{ package Card;
  use strict; use warnings;
  use overload
    '""' => sub { shift->as_string },
    '0+' => sub { shift->as_number },
    bool     => sub { 1 },
    fallback => 1;

  sub new { bless \(my $r = $_[1]), $_[0] }

  sub as_string {
    my ($self) = @_;
    for ($$self) {
      if ($_ eq '1')  { return 'A' }
      if ($_ eq '11') { return 'J' }
      if ($_ eq '12') { return 'Q' }
      if ($_ eq '13') { return 'K' }
      return $$self
    }
  }

  sub as_number {
    my ($self) = @_;
    for ($$self) {
      if ($_ eq 'A') { return 1 }
      if ($_ eq 'J') { return 11 }
      if ($_ eq 'Q') { return 12 }
      if ($_ eq 'K') { return 13 }
      return $$self
    }
  }
}

sub new_deck {
  my $cards = [];
  for my $val (2 .. 10, qw/A J Q K/) {
    $cards->push( Card->new($_) ) for 1 .. 4
  }
  $cards->shuffle
}

sub compare_totals {
  my ($players, $dealers) = @_;
  my $players_total = $players->reduce(sub { shift() + shift() });
  my $dealers_total = $dealers->reduce(sub { shift() + shift() });
  my $player_abs = abs($players_total - 21);
  my $dealer_abs = abs($dealers_total - 21);
  my $winner = $player_abs < $dealer_abs ? 'player' : 'dealer';
  hash(
    winner => $winner,
    players_total => $players_total,
    dealers_total => $dealers_total
  )->inflate
}

my $scoreboard = hash(player => 0, dealer => 0)->inflate(rw => 1);

while (1) {
  my $player_score = $scoreboard->player;
  my $dealer_score = $scoreboard->dealer;
  print "Scoreboard: [player $player_score]  [dealer $dealer_score]\n\n";
  my $deck = new_deck;
  my $player_gets = $deck->splice(0, 2);
  my $dealer_gets = $deck->splice(0, 2);
  print 
    " You have: ", $player_gets->join(' '),
    " (total: ", $player_gets->reduce(sub { shift() + shift() }), ")\n",
    " -> 'h'it, 's'tay, 'q'uit:\n> ";
  my $cmd = <STDIN>;
  chomp $cmd;
  CMD: {
    if ($cmd eq 'q' || $cmd eq 'quit') {
      exit 0
    }
    if ($cmd eq 'h' || $cmd eq 'hit') {
      my $newcard = $deck->shift;
      $player_gets->push( $newcard );
      print 
        " Drew $newcard (", $newcard + 0,")",
        " (total: ", 
        $player_gets->reduce(sub { shift() + shift() }),
        ")\n";
      last CMD
    }
    if ($cmd eq 's' || $cmd eq 'stay') {
      last CMD
    }
    warn "Unknown command: $cmd\n";
    redo CMD
  }

  unless ($dealer_gets->reduce(sub { shift() + shift() }) > 17) {
    $dealer_gets->push( $deck->shift )
  }

  my $winner = compare_totals($player_gets, $dealer_gets);
  if ($winner->winner eq 'player') {
    $scoreboard->player( $scoreboard->player + 1 );
    print
      "You won!\n",
      " -> player had ", $winner->players_total, "\n",
      " -> dealer had ", $winner->dealers_total, "\n";
  } else {
    $scoreboard->dealer( $scoreboard->dealer + 1 );
    print 
      "You lost!\n",
      " -> dealer had ", $winner->dealers_total, "\n",
      " -> player had ", $winner->players_total, "\n";
  }

  print "Enter to play again . . . \n";
  <STDIN>
}

