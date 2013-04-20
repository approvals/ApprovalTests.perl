use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'Test::Approvals',
    license            => 'apache',
    dist_author        => q{Jim Counts <jamesrcounts@outlook.com>},
    dist_version_from  => 'lib/Test/Approvals.pm',
    release_status     => 'unstable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'autodie'        => 0,
        'Capture::Tiny'  => 0,
        'Carp'           => 0,
        'English'        => 0,
        'Exporter'       => 0,
        'File::Compare'  => 0,
        'File::Next'     => 0,
        'File::Spec'     => 0,
        'File::stat'     => 0,
        'FindBin::Real'  => 0,
        'Getopt::Euclid' => 0,
        'Modern::Perl'   => 0,
        'Moose'          => 0,
        'Moose::Role'    => 0,
        'Readonly'       => 0,
        'Storable'       => 0,
        'Test::Builder'  => 0,
        'version'        => 0,
    },
    add_to_cleanup     => ['Test-Approvals-*'],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
