#! perl
use strict;
use warnings FATAL => qw(all);
use version; our $VERSION = qv(0.0.1);

use Test::Approvals::Namers::DefaultNamer;
use Test::More;

my $context;
my @specs;

sub describe {
    $context = shift;
    my $specs = shift;
    $specs->();
    return;
}

sub it {
    my $name = shift;
    my $spec = shift;
    push @specs, sub { $spec->("$context $name") };
    return;
}

sub run_tests {
    plan tests => scalar @specs;
    for (@specs) { $_->(); }
    return;
}

describe 'A Namer', sub {
    my $n = Test::Approvals::Namers::DefaultNamer->new(
        directory => 'c:\\tmp',
        name      => 'foo'
    );

    it 'Provides the approved filename', sub {
        my ($spec) = @_;
        is $n->get_approved_file('txt'), 'C:\\tmp\\namer.t.foo.approved.txt',
          $spec;
    };

    it 'Provides the received filename', sub {
        my ($spec) = @_;
        is $n->get_received_file('txt'), 'C:\\tmp\\namer.t.foo.received.txt',
          $spec;
    };

    it 'Cleans the input when necessary', sub {
        my ($spec) = @_;
        my $o = Test::Approvals::Namers::DefaultNamer->new(
            directory => 'c:/tmp/',
            name      => 'foo.'
        );
        is $o->get_received_file('.txt'), 'C:\\tmp\\namer.t.foo.received.txt',
          $spec;
    };
};

run_tests();
