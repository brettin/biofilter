
# Abstract Record Class
# Thomas Brettin, 2002, 2009
package Record;
# use base qw(Class::Virtually::Abstract);
# __PACKAGE__->virtual_methods('get','set');

use Storable qw(dclone);

sub new {
    my $class = shift or die "could not get classname";
    die "can not call new on abstract class DbRecordn" if $class eq 'Record';

    $self->{'allowed_attributes'} = [];
    bless $self, $class;
}

sub get {
  my $self = shift or die" could not get self reference";
  die "can not call get on abstract class Record" if ref $self eq 'Record';
  my $hash = {};

  # make a shallow copy of $self ommitting the database conn.
  # future changes that add 'private' vars to this class will
  # need to update this section so that the private vars don't
  # get returned as part of the copied hash.
  foreach (keys (%$self)) {
    $hash->{$_} = $self->{$_} unless $_ eq 'dbaccess' or
	                             $_ eq 'allowed_attributes';
  }

  # now return a deep copy of the hash

  dclone $hash;
}

sub set {
  my $self = shift or die "could note get reference to self";
  my $hash = shift or die "need to pass in a hash ref";
  die "can not call set on abstract class Record" if ref $self eq 'Record';

  # clear all pre-existing values
  # $self->{$_} = undef foreach (keys (%$self));

  # validate that keys in the incoming hash are allowed_attributes
  # foreach key in the incoming hash, make sure it is in allowed_attributes
  die "did you forget to call setAllowedAttributes in the derived class?"
	unless @{$self->{'allowed_attributes'}} > 0;
  foreach (keys(%$hash)) {
	die ("$_ not found in allowed_attributes when set called by ", caller)
	  unless grep /^$_$/i, @{$self->{'allowed_attributes'}};
  }

  # make a deep copy of the incoming hash
  $hash = dclone($hash);

  # set new values
  $self->{lc $_} = $hash->{$_} foreach (keys(%$hash));

  # return $self;
  return;
}



sub setAllowedAttributes {
  my $self = shift;
  $self->{allowed_attributes} = shift if defined $_[0] and
	                                     ref($_[0]) eq 'ARRAY';
  return;
}

sub AUTOLOAD {
  my $self = shift or die "could not get self reference";

  # split the fully qualified method name that was called.
  my @parts = split(/::/, $AUTOLOAD);
  my $method = $parts[$#parts];

  # check to see if allowed_attributes is set, if it is, then check
  # the method against the set of allowed attributes
  if (defined $self->{allowed_attributes} and
	  @{$self->{allowed_attributes}} > 0 ) {
	die "$method setter/getter not found in allowed_attributes " , caller()
	    unless grep (/^$method$/i, @{$self->{allowed_attributes}} );
  }

  # have to handle the case when DESTROY is called but not implemented.
  if ($method eq 'DESTROY' ) {
    print "please implement DESTROY";
    return;
  }

  # set the new object attribute if a value was passed in.
  $self->{lc $method} = shift if defined $_[0];

  # return the current value of the object attribute.
  return $self->{lc $method};
}

sub DESTROY {
  # print "DESTROY called\n"
}

1;



