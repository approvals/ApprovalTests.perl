#! perl

use Modern::Perl '2013';
use warnings FATAL => 'all';
use autodie;

use File::Next;
use Getopt::Euclid;

my $print_info = $ARGV{-v};
my $input      = $ARGV{-i};

if ($print_info) {
    print "Looking for Perl sources in $input\n";
    print "perltidy options: $ARGV{-P}\n";
}

my $next_file = File::Next::files(
    {
        descend_filter => sub { $_ ne ".git" },
        file_filter => sub { $_ !~ /tidyall.pl/ && $_ =~ /[.]pl$|[.]pm$|[.]t$/ }
    },
    $input
);

while ( defined( my $file = $next_file->() ) ) {
    my $perltidy = "perltidy $ARGV{-P} $file";
    if ($print_info) {
        print "$perltidy\n";
    }

    system $perltidy ;
}

__END__

=head 1 NAME

tidyall - Recursively find all Perl sources and run perltidy on them all

=head 1 VERSION

This documentation referes to tidyall version 0.0.1

=head 1 USAGE

   tidyall -in .\directory [options]

=head1 OPTIONS

=over

=item -i[n] [=] <directory>

Specify input directory

=for Euclid
		directory.type: readable
		directory.default: '.'

=item -P [=] <opts>

=for Euclid
		opts.default: '-b'

perltidy options

=item -v

=item --verbose

Print all warnings

=item --version

=item --usage

=item --help

=item --man

Print the usual program information

=back
