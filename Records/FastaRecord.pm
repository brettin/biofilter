# Concrete Source Class
package FastaRecord;

=head1 NAME

FastaRecord

=head1 SYNOPSIS

  $fr = FastaRecord->new();

=head1 DESCRIPTION

=head1 METHODS

=cut

use base qw(Record);


sub new {
  my $class  = shift;
  my ($defline, @seq_lines, $sequence);

  my $record;
  if (defined $_[0]) {
    $record = shift;
    # print "record=$record";
    ($defline,@seq_lines) = split (/\n+/,$record);
    # error check, does it look like a fasta record
    if ($defline !~ /^>/) {warn "funny looking defline, $defline";  return;}
    if (@seq_lines == 0)  {warn "funny looking sequence,@seq_lines";return;}
    $sequence = join ("\n",@seq_lines);
  }
  bless {'defline' => $defline, 'sequence' => $sequence,
	 'word_separator' => '[\|,\s]','word_number' => 2,
	 'record' => $record,
	}, $class;
}
sub get {
  my $self = shift;
  return $self->{'record'} if defined $self->{'record'};
}
sub getSequence {
  my $self = shift;
  return $self->{sequence} if defined ($self->{sequence});
}
sub getDefline{
  my $self = shift;
  #print "word sep:$self->{word_separator}\nword_num:$self->{word_number}\n";
  if((defined ($self->{word_separator})) && (defined ($self->{word_number}))){
        my ($dum,$temp_defline);
	($dum,$temp_defline)=split('>',$self->{defline});
	#$self->{defline}=$temp_defline
	my @defline_parts=split(/$self->{word_separator}/,$temp_defline);
	return  ">$defline_parts[$self->{word_number}-1]";
  }
  return $self->{defline} if defined ($self->{defline});
}

sub set {
  my $self = shift;
  if (defined $_[0]) {
    my $record = shift;
    my ($defline,@seq_lines) = split (/\n/,$record);
    # error check, does it look like a fasta record
    if ($defline !~ /^>/) {warn "funny looking defline,  $defline"; return;}
    if (@seq_lines == 0)  {warn "funny looking sequence, @seq_lines";return;}
    $sequence = join ("\n",@seq_lines);
    $self->{record} = $record;
    $self->{defline} = $defline;
    $self->{sequence} = $sequence;
  }
  return $self;
}
#sets the separator for the defline
# example if defline is gi|wc-01|xxx| the separator could be |
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

#sets the word number to return from the defline
# example if defline is gi|wc-01|xxx| and the separator is | then word_number =1 will be gi

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
