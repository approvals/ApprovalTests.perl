#! perl

use strict;
use warnings;

use FindBin::Real qw(Bin );
use Test::More;
use Test::Approvals::Namer;

sub test {
    my ( $test_name, $test_method ) = @_;

    my $working_dir = Bin();

    $test_method->( Test::Approvals::Namer->new( test_name => $test_name ) );
}

test(
    "Namer finds directory.",
    sub {
        my ($namer) = @_;
        ok( -e $namer->get_directory() . 'simple.t', $namer->test_name() );
    }
);

test "Don't need the namer", sub { ok(1); };
test "Namer knows approval file", sub {
    my ($namer) = @_;
    like( $namer->get_approved_file("txt"),
        qr/simple\.t\.namer_knows_approval_file\.approved\.txt$/ );
};

test "Namer knows received file", sub {
    my ($namer) = @_;
    like( $namer->get_received_file("txt"),
        qr/simple\.t\.namer_knows_received_file\.received\.txt$/ );
};

done_testing();
