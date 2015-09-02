# Concrete Source Class
package FastaRecordsFile;

=head1 NAME

FastaRecordsFile

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

use base qw(RecordsFile);
use FastaRecord;

#find how many fasta sequences in the file
sub getRecordNumber {
  my $self = shift;
  my $record_number = 0;
  while (my $line = readline(*{$self->{handle}})) {
    if ($line =~ /^>/) {
        $record_number ++;
    }
  }
  return $record_number;
}

sub getRecord {
  my $self = shift;
  my $record;
  while (my $line = readline(*{$self->{handle}})) {
    if ((!$record) && ($line !~ /^>/)) {
	  warn('next line did not start with >');
      next;
    }
    if (($record) && ($line =~ /^>/)) {
      seek ($self->{handle}, -length($line), 1);
      last;
    }
    $record .= $line if($line =~ /\S/);
  }
  if (defined ($record)) {
    $self->{original_record} = FastaRecord->new($record);
    if (defined $self->{word_separator}){

	$self->{original_record}->setWordSeparator($self->{word_separator});
	
    }
	
    if (defined $self->{word_number}){
	$self->{original_record}->setWordNumber($self->{word_number});

    }

    return $self->{original_record};
  }
}

#sets the separator for the FastaRecordsFile which in  turn will
#set it for each FastaRecord it creates in the getRecord method
sub setWordSeparator{

  my $self=shift;
  if(defined $_[0]){
        $self->{word_separator}=$_[0];
  }
  else{
        die "Argument Word Separator expected as input in ",__PACKAGE__,"::setWord\n";
  }


  return $self->{word_separator};
}

#sets the word number for each FastaRecord
sub setWordNumber{

  my $self=shift;
  if(defined $_[0]){
	$self->{word_number}=$_[0];
  }
  else{
	die "Argument Word Number expected as input in ",__PACKAGE__,"::setWord\n";
  }

  return $self->{word_number};
}


=head1 AUTHORS

Thomas S. Brettin

=cut

1;
