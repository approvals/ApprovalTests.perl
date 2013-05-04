use 5.014;
use strict;
use warnings FATAL => 'all';
use Module::Build;

BEGIN {
    if ( $^O ne 'MSWin32' ) {
        die "No support for OS\n";
    }
}

my $builder = Module::Build->new(
    module_name          => 'Test::Approvals',
    license              => 'apache',
    dist_author          => q{Jim Counts <jamesrcounts@outlook.com>},
    dist_version_from    => 'lib/Test/Approvals.pm',
    release_status       => 'testing',
    recursive_test_files => 1,
    configure_requires   => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl'            => 5.014000,
        'autodie'         => 0,
        'version'         => 0,
        'Capture::Tiny'   => 0,
        'Carp'            => 0,
        'English'         => 0,
        'Exporter'        => 0,
        'File::stat'      => 0,
        'File::Compare'   => 0,
        'File::Next'      => 0,
        'File::Spec'      => 0,
        'File::Touch'     => 0,
        'FindBin::Real'   => 0,
        'Getopt::Euclid'  => 0,
        'List::MoreUtils' => 0,
        'List::Util'      => 0,
        'Modern::Perl'    => 0,
        'Moose'           => 0,
        'Moose::Role'     => 0,
        'Moose::Util'     => 0,
        'Perl6::Slurp'    => 0,
        'Readonly'        => 0,
        'Storable'        => 0,
        'Test::Builder'   => 0,
        'Win32::Process'  => 0,
    },
    add_to_cleanup => [
        'Test-Approvals-*',
        '*.bak',
        'tools/*.bak',
        't/*.bak',
        't/Reporters/*.bak',
        'lib/Test/Approvals/Core/*.bak',
        'lib/Test/Approvals/Namers/*.bak',
        'lib/Test/Approvals/Reporters/*.bak',
        'lib/Test/Approvals/Writers/*.bak',
        'lib/Test/Approvals/*.bak',
        'lib/Test/*.bak',
    ],    
);

$builder->create_build_script();
