package Library::MLang;

require v5.6.0;
use strict;
use warnings;

require Exporter;

# Module Stuff
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( &loadMLangFile );

# Version
our $VERSION = '0.04';

sub str {
  my $self = shift;
  my $text = shift;
  $text=~s/\[(\w+)\]/$self->get($1)/eg;
  return $text;
}

sub print {
  my $self = shift;
  my $t;
  while ($t = shift) {
    print $self->str($t);
  }
}

sub languages {
  my $self = shift;
  return sort keys %{$self->{languages}};
}

sub loadMLangFile {
    my $filename = shift;
    my $ling = shift;
    my $self;

    my $old_sep = $/;
    $/ = "\n\n";

    open F, $filename or die "Cannot open file $filename";
    while(<F>) {
      my @lines = split /\n/;
      my $id = shift @lines;
      for my $line (@lines) {
	$line =~ m{^([a-z]+):\s*};
	my $lang = $1;
        $self->{languages}->{$lang}++;
	my $message = $';
	$self->{messages}->{$id}->{$lang}=$message;
      }
    }
    close F;
    $/ = $old_sep;

    $self->{language} = $ling || (keys %{$self->{languages}})[0];

    return bless($self);
}

sub setLanguage {
  my $self = shift;
  my $language = shift || $self->{language};
  $self->{language}=$language;
}

sub get {
  my $self = shift;
  my $id = shift;
  if (defined($self->{messages}->{$id})) {
    if (defined($self->{messages}->{$id}->{$self->{language}})) {
      return $self->{messages}->{$id}->{$self->{language}};
    } else {
      warn("Term $id not defined on $self->{language}");
      return "n/a";
    }
  }else {
    warn("Term $id not defined!");
    return "n/a";
  }
}

1;
__END__

=head1 NAME

Library::MLang - Perl extension for managing multi-linguagal messages in perl scripts

=head1 SYNOPSIS

  use Library::MLang;

  $messages = loadMLangFile('file.lang');

  $messages->setLanguage('en');

  $messages->get('ERRO_OP');

=head1 DESCRIPTION

to be completed

=head1 AUTHOR

Alberto M. Simões <albie@alfarrabio.um.geira.pt>

=head1 SEE ALSO

perl(1).

=cut

);


