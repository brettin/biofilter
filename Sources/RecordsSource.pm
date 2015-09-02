package RecordsSource;

sub getRecord {
  die "must implement getRecord\n";
}

sub setSource {
  die "must implement setSource\n";
}

sub eof {
  die "must implement eof\n";
}

sub resetSource {
  die "must implement resetSource\n";
}

1;
