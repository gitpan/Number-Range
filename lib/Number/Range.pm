package Number::Range;

use strict;
use warnings;
use warnings::register;
use Carp;

require Exporter;

our @ISA = qw(Exporter);


our $VERSION = '0.01';

sub new {
	my $this = shift;
	my $class = ref($this) || $this;
	my $self = {};
	bless $self, $class;
	$self->initialize(@_);
	return $self;
}

sub initialize {
  my $self = shift;
  my $rangesep = qr/(?:\.\.)/;
  my $sectsep  = qr/(?:\s|,)/;
  my $validation = qr/(?:
       [^0-9,. -]|        # These are the only allowed characters (Numbers and "seperators")
       $rangesep$sectsep| # We don't want a range seperator followed by section seperator
       $sectsep$rangesep| # We don't want a section seperator followed by range seperator
       \d-\d|             # We don't want 10-10 since - is for negative numbers
       ^$sectsep|         # We don't want a section seperator at the start
       ^$rangesep|        # We don't want a range seperator at the start
       $sectsep$|         # We don't want a section seperator at the end
       $rangesep$         # We don't want a range seperator at the end
       )/x;
  foreach my $item (@_) {
 	  croak "$item contains invalid data" if ($item =~ m/$validation/g);
 	  foreach my $section (split(/$sectsep/, $item)) {
 	  	if ($section =~ m/$rangesep/) {
 	  		my ($start, $end) = split(/$rangesep/, $section, 2);
 	  		if ($start > $end) {
 	  			carp "$start is > $end" if (warnings::enabled());
 	  			($start, $end) = ($end, $start);
 	  		}
 	  		if ($start == $end) {
 	  			carp "$start:$end is pointless" if (warnings::enabled());
 	  			$self->_addnumbers($start);
 	  		}
 	  		else {
 	  		  $self->_addnumbers($start .. $end);
 	  		}
 	  	}
 	  	else {
 	  		$self->_addnumbers($section);
 	  	}
 	  }
  }
}

sub _addnumbers {
	my $self = shift;
	foreach my $number (@_) {
		if (warnings::enabled()) {
	    carp "$number already in range" if $self->inrange($number);
	  }
		$self->{_rangehash}{$number} = 1;
	}
}

sub inrange {
	my $self   = shift;
	my $number = shift;
  return (exists($self->{_rangehash}{$number})) ? 1 : 0;
}


1;
__END__

=head1 NAME

Number::Range - Perl extension defining ranges of numbers and testing 
later if a number is in it

=head1 SYNOPSIS

  use Number::Range;
  
  my $range = Number::Range->new("-10..10,12,100..120");
  if ($range->inrange("13")) {
  	print "In range\n";
  } else {
  	print "Not in range\n";
  }

=head1 DESCRIPTION

Number::Range will take a description of range(s), and then allow you to
test later on if a number falls within the range(s).

=head2 RANGE FORMAT

The format used for range is pretty straight forward. To separate sections
of ranges it uses a C<,> or whitespace. To create the range, it uses C<..> to
do this, much like Perl's own binary C<..> range operator in list context.

=head2 EXPORT

None by default.

=head1 AUTHOR

Larry Shatzer, Jr., E<lt>larrysh@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Larry Shatzer, Jr.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
