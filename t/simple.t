#! perl

use strict;
use warnings FATAL => 'all';

use version; our $VERSION = qv(0.0.1);

use FindBin::Real qw(Bin);
use Test::More;
use Test::Approvals::Namer;
use Test::Approvals::Core::FileApprover qw(verify_files verify_parts);
use Test::Approvals::Reporters;
use Test::Approvals::Writers::TextWriter;

use Readonly;

sub test {
    my ( $test_name, $test_method ) = @_;

    my $working_dir = Bin();

    $test_method->( Test::Approvals::Namer->new( test_name => $test_name ) );
    return;
}

sub verify {
    my ( $test_name, $reporter, $test_method ) = @_;
    $reporter =
      $reporter || Test::Approvals::Reporters::IntroductionReporter->new();
    my $namer  = Test::Approvals::Namer->new( test_name => $test_name );
    my $result = $test_method->($namer);
    my $writer = Test::Approvals::Writers::TextWriter->new(
        result         => $result,
        file_extension => '.txt'
    );
    my $test_more_reporter =
      Test::Approvals::Reporters::TestBuilderReporter->new(
        test_name => $namer->test_name() );
    my $full_reporter =
      Test::Approvals::Reporters::AndReporter->new(
        reporters => [ $test_more_reporter, $reporter ] );
    verify_parts( $writer, $namer, $full_reporter );
    return;
}

{
    Readonly my $REPORTER => Test::Approvals::Reporters::DiffReporter->new();

    verify 'Verify Hello World', $REPORTER, sub {
        return 'Hello World';
    };
}

test 'Approve file does not exist', sub {
    my ($namer) = @_;
    my $reporter = Test::Approvals::Reporters::FakeReporter->new();
    verify_files( 'file_that_does_not_exist', 'a.txt', $reporter );
    ok( $reporter->was_called(), $namer->test_name() );
};

test 'Test Files Match', sub {
    my ($namer) = @_;

    my $writer = Test::Approvals::Writers::TextWriter->new( result => "a.txt" );
    my $approved = 't/a1.txt';
    $writer->write($approved);

    my $received = 't/a.txt';
    $writer->write($received);

    my $reporter = Test::Approvals::Reporters::FakeReporter->new();
    verify_files( $approved, $received, $reporter );
    ok( !$reporter->was_called(), $namer->test_name() );
};

test 'Namer finds directory', sub {
    my ($namer) = @_;
    ok( -e $namer->get_directory() . 'simple.t', $namer->test_name() );
};

test 'Namer knows approval file', sub {
    my ($namer) = @_;
    like(
        $namer->get_approved_file('txt'),
        qr/simple[.]t[.]namer_knows_approval_file[.]approved[.]txt\z/mxs,
        $namer->test_name()
    );
};

test 'Namer knows received file', sub {
    my ($namer) = @_;
    like(
        $namer->get_received_file('txt'),
        qr/simple[.]t[.]namer_knows_received_file[.]received[.]txt\z/mxs,
        $namer->test_name()
    );
};
test 'Namer provides dot for extension', sub {
    my ($namer) = @_;
    my $name = qr{namer_provides_dot_for_extension}misx;
    like(
        $namer->get_received_file('.txt'),
        qr/simple[.]t[.]$name[.]received[.]txt\z/mxs,
        $namer->test_name()
    );
};

done_testing();
