#! perl
use strict;
use warnings FATAL => qw(all);

package Test::Approvals::Specs;

use version; our $VERSION = qv(0.0.1);
use base qw(Exporter);
our @EXPORT_OK = qw(describe it run_tests);

use Test::Builder;
use Readonly;

Readonly my $TEST => Test::Builder->new();

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
    my $other_tests = shift // 0;
    $TEST->plan( tests => ( scalar @specs + $other_tests ) );
    for (@specs) { $_->(); }
    return;
}

1;
