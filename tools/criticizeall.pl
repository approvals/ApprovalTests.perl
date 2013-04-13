#! perl

use Modern::Perl '2012';
use warnings FATAL => 'all';
use autodie;

use File::Next;
use File::Spec;
use File::stat;
use FindBin::Real qw(Bin Script);
use Getopt::Euclid;
use Storable;

my $print_info = $ARGV{-v};
my $input      = $ARGV{-i};
my $force      = $ARGV{'-f'};
my $cache      = File::Spec->catfile( Bin(), '_cmtimes' );

if ($print_info) {
    print "Looking for Perl sources in $input\n";
    print "perlcritic options: $ARGV{-C}\n";
}

my $next_file = File::Next::files(
    {
        descend_filter => sub { $_ ne ".git" && $_ ne 'blib' },
        file_filter => sub { $_ =~ /[.]pl$|[.]pm$|[.]t$/ }
    },
    $input
);

my %mtimes = -e $cache ? %{ retrieve($cache) } : ();

while ( defined( my $file = $next_file->() ) ) {
    my $mtime = stat($file)->mtime;
    if ( !$force and $mtime ~~ $mtimes{$file} ) {
        next;
    }

    my $perlcritic = "perlcritic $ARGV{-C} $file";
    if ($print_info) {
        print "$perlcritic\n";
    }

    system $perlcritic;
    $mtimes{$file} = stat($file)->mtime;
    store \%mtimes, $cache;
}

__END__

=head 1 NAME

criticizeall - Recursively find Perl sources and run perlcritic on them all

=head 1 VERSION

This documentation referes to criticizeall version 0.0.1

=head 1 USAGE

   criticizeall -in .\directory [options]

=head1 OPTIONS

=over

=item -i[n] [=] <directory>

Specify input directory

=for Euclid
		directory.type: readable
		directory.default: '.'

=item -C [=] <opts>

=for Euclid
		opts.default: '-1'

criticizeall options

=item -f

Force criticism, even if the file appears unmodified.

=item -v

=item --verbose

Print all warnings

=item --version

=item --usage

=item --help

=item --man

Print the usual program information

=back

=head1 DEPENDENCIES

=over

    autodie
    File::Next
    File::Spec
    File::stat
    FindBin::Real
    Getopt::Euclid
    Modern::Perl 2012
    Storable

=back

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

None known.

=head1 AUTHOR

Jim Counts - @jamesrcounts

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2013 Jim Counts

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    L<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

