use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'Test::Approvals',
    license            => 'apache',
    dist_author        => q{Jim Counts <jamesrcounts@outlook.com>},
    dist_version_from  => 'lib/Test/Approvals.pm',
    release_status     => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'autodie'       => 0,
        'English'       => 0,
        'FindBin::Real' => 0,
        'Perl6::Slurp'  => 0,
        'Readonly'      => 0,
        'Test::More'    => 0,
        'version'       => 0,
    },
    requires => {
        'Capture::Tiny'   => 0,
        'Carp'            => 0,
        'Exporter'        => 0,
        'File::Compare'   => 0,
        'File::Next'      => 0,
        'File::Spec'      => 0,
        'File::stat'      => 0,
        'Getopt::Euclid'  => 0,
        'List::MoreUtils' => 0,
        'List::Util'      => 0,
        'Modern::Perl'    => 0,
        'Moose'           => 0,
        'Moose::Role'     => 0,
        'Moose::Util'     => 0,
        'Storable'        => 0,
        'Test::Builder'   => 0,
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
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
