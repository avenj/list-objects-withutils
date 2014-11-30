use strict; use warnings FATAL => 'all';

my $id = 0;

{ package Widget;
  use Moo;
  has id => ( is => 'ro', default => sub { ++$id } );
  sub execute { 
    my $self = shift;
    print "Widget ".$self->id." present!\n"
  }
}

{ package Machine;

  use List::Objects::WithUtils;
  use Types::Standard -types;

  use Moo;

  has widgets => (
    is      => 'ro',
    default => sub { array_of InstanceOf['Widget'] },
    handles => +{
      add_widgets  => 'push',
      list_widgets => 'all',
      each_widget  => 'visit',
    },
  );
}

my $machine = Machine->new;
my @widgets = map {; Widget->new } 1 .. 4;
$machine->add_widgets(@widgets);

$machine->each_widget(sub { $_->execute });
