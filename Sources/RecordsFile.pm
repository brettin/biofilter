package RecordsFile;

# Thomas S. Brettin
# Copywrite 2001-2002, Brettin Inc.
# Modified 2009 at ORNL

# Using the constructor from the IO::Handle package (or one of its
# subclasses, such as IO::File or IO::Socket), you can generate
# anonymous filehandles that have the scope of whatever variables
# hold references to them, and automatically close whenever and
# however you leave that scope. Inorder to instanciate multiple
# source objects, each with a different filehandle, anonymous
# filehandles are used.

=head1 NAME

RecordsFilter

=head1 SYNOPSIS

  use base qw(RecordsFile);

=head1 DESCRIPTION

Base class for file based record sources.

=head1 METHODS

=cut


use base qw(RecordsSource);
use IO::Handle;

my $DEBUG = 1;

sub new {
  my($class, $file) = @_;

  if (defined $file ) {
	-e $file or die "$file does not exist: ", caller;
	-r $file or die "$file is not readable: ", caller;
  }
  else {
	$file = undef;
  }

  my $handle = IO::Handle->new();
  if(defined $file && open($handle, $file)) {
    my $self = bless ({'handle'          => $handle,
                       'file'            => $file,
					   'original_record' => undef,
					   'consumer'        => undef},
                      $class);
    return $self;
  }
  else {
    return bless ({'handle'          => undef,
                   'file'            => $file,
				   'original_record' => undef,
				   'consumer'        => undef},
				  $class);
  }
}

sub resetSource {
  my $self = shift;
  die "invalid file handle in call to resetSource\n" 
    unless ($self->{handle});
  seek ($self->{handle}, 0, 0) or die "seek failed in resetSource\n";
  return;
}

sub eof {
  my $self = shift;
  my $return;
  if (eof(*{$self->{'handle'}})) {
	$return = 1;
  }
  else {
	$return = 0;
  }
}

sub seekBack(){
  my $self=shift;
  seek($self->{handle},-length($self->{original_record}->get()),1);
}


sub DESTROY {
  my $self = shift;
  if($self->{'handle'}) {
    close $self->{'handle'};
  }
}

sub setConsumer{
  my $self=shift;
  $self->{consumer}=shift;
}

sub getConsumer{
  my $self=shift;
  if (defined($self->{consumer})){
    return $self->{consumer};
  }
  return undef;
}

sub setSource {
  my ($self, $file) = @_;
  my $handle = IO::Handle->new();
  if(open($handle, "$file")) {
    $self->{'handle'} = $handle;
    $self->{'file'}   = $file;
  }
  else {
    die "call to setSource did not open file $file\n";
  }
  return;
}

1;
