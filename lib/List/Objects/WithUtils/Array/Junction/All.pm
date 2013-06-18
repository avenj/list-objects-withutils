package List::Objects::WithUtils::Array::Junction::All;
use strictures 1;
use parent 'List::Objects::WithUtils::Array::Junction';

sub num_eq {
  return regex_eq(@_) if ref $_[1] eq 'Regexp';
  for (@{ $_[0] })
    { return unless $_ == $_[1] }
  1
}

sub num_ne {
  return regex_ne(@_) if ref $_[1] eq 'Regexp';
  for (@{ $_[0] })
    { return unless $_ != $_[1] }
  1
}

sub num_ge {
  return num_le( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return unless $_ >= $_[1] }
  1
}

sub num_gt {
  return num_lt( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return unless $_ > $_[1] }
  1
}

sub num_le {
  return num_ge( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return unless $_ <= $_[1] }
  1
}

sub num_lt {
  return num_gt( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return unless $_ < $_[1] }
  1
}

sub str_eq {
  for (@{ $_[0] })
    { return unless $_ eq $_[0] }
  1
}

sub str_ne {
  for (@{ $_[0] })
    { return unless $_ ne $_[0] }
  1
}

sub str_ge {
  return str_le( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return unless $_ ge $_[1] }
  1
}

sub str_gt {
  return str_lt( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return unless $_ gt $_[1] }
  1
}

sub str_le {
  return str_ge( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return unless $_ le $_[1] }
  1
}

sub str_lt {
  return str_gt( @_[0, 1] ) if $_[2];
  for (@{ $_[0] })
    { return unless $_ lt $_[1] }
  1
}

sub regex_eq {
  for (@{ $_[0] })
    { return unless $_ =~ $_[1] }
  1
}

sub regex_ne {
  for (@{ $_[0] })
    { return unless $_ !~ $_[1] }
  1
}

sub bool {
  for (@{ $_[0] })
    { return unless $_ }
  1
}

1;
