package List::Objects::WithUtils::Array::Junction::Any;
use strictures 1;
use parent 'List::Objects::WithUtils::Array::Junction::Base';

sub num_eq {
  return regex_eq(@_) if ref $_[1] eq 'Regexp';
  for (@{ $_[0] }) 
    { return 1 if $_ == $_[1] }
  ()
}

sub num_ne {
  return regex_eq(@_) if ref $_[1] eq 'Regexp';
  for (@{ $_[0] })
    { return 1 if $_ != $_[1] }
  ()
}

sub num_ge {
  return num_le( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return 1 if $_ >= $_[1] }
  ()
}

sub num_gt {
  return num_lt( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return 1 if $_ > $_[1] }
  ()
}

sub num_le {
  return num_ge( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return 1 if $_ <= $_[1] }
  ()
}

sub num_lt {
  return num_gt( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return 1 if $_ < $_[1] }
  ()
}

sub str_eq {
  for (@{ $_[0] })
    { return 1 if $_ eq $_[1] }
  ()
}

sub str_ne {
  for (@{ $_[0] })
    { return 1 if $_ ne $_[1] }
  ()
}

sub str_ge {
  return str_le( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return 1 if $_ ge $_[2] }
  ()
}

sub str_gt {
  return str_lt( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return 1 if $_ gt $_[2] }
  ()
}

sub str_le {
  return str_ge( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return 1 if $_ le $_[2] }
  ()
}

sub str_lt {
  return str_gt( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return 1 if $_ lt $_[2] }
  ()
}

sub regex_eq {
  for (@{ $_[0] })
    { return 1 if $_ =~ $_[1] }
  ()
}

sub regex_ne {
  for (@{ $_[0] })
    { return 1 if $_ !~ $_[1] }
  ()
}

sub bool {
  for (@{ $_[0] })
    { return 1 if $_ }
  ()
}

1;
