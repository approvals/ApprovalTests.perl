#! perl

use strict;
use warnings;

package Test::Approvals::Reporter;
{
    use Moose;

    has 'was_called', isa => 'Int', is => 'rw', default => 0;

    sub report {
        my ( $self, $approved, $received ) = @_;
        $self->was_called(1);
    }
}

package Test::Approvals::Reporters::TortoiseDiffReporter;
{
    use Moose;
    use File::Touch;
    use Win32::Process;
    use FindBin::Real qw(Bin);

    sub report {
        my ( $self, $approved, $received ) = @_;

        $approved =~ s{/}{\\\\}gmisx;
        $received =~ s{/}{\\\\}gmisx;

        my $bin = "C:\\Program Files\\TortoiseSVN\\bin\\";
        my $exe      = "tortoisemerge.exe";
        touch($approved);

        my $process;
        Win32::Process::Create(
            $process,
            "$bin$exe",
            "\"$bin$exe\" \"$received\" \"$approved\"",
            0,
            DETACHED_PROCESS,
            Bin());
    }
}

package Test::Approvals::Reporters::TestMoreReporter;
{
    use Moose;
}

package Test::Approvals::Reporters::AndReporter;
{
    use Moose;
}

package Test::Approvals::Writers::TextWriter;
{
    use Moose;
    use Carp;
    use English qw(-no_match_vars);

    has result         => ( is => 'ro', isa => 'Str', default => q{} );
    has file_extension => ( is => 'ro', isa => 'Str', default => 'txt' );

    sub write {
        my ( $self, $path ) = @_;
        open my $file, '>', $path
          or croak "Could not open $path for writing: $OS_ERROR";
        print {$file} $self->result()
          or croak "Could not write to $path: $OS_ERROR";
        close $file or croak "Could not close $path after writing: $OS_ERROR";

        return $path;
    }
}

package main;
use FindBin::Real qw(Bin );
use Test::More;
use Test::Approvals::Namer;
use Test::Approvals::Core::FileApprover qw(verify_files verify_parts);
use Readonly;

sub test {
    my ( $test_name, $test_method ) = @_;

    my $working_dir = Bin();

    $test_method->( Test::Approvals::Namer->new( test_name => $test_name ) );
}

sub verify {
    my ( $test_name, $reporter, $test_method ) = @_;
    my $namer  = Test::Approvals::Namer->new( test_name => $test_name );
    my $result = $test_method->($namer);
    my $writer = Test::Approvals::Writers::TextWriter->new(
        result         => $result,
        file_extension => '.txt'
    );
    my $test_more_reporter =
      Test::Approvals::Reporters::TestMoreReporter->new(
        name => $namer->test_name() );
    my $full_reporter =
      Test::Approvals::Reporters::AndReporter->new( $test_more_reporter,
        $reporter );
    verify_parts( $writer, $namer, $reporter );
}

{
    Readonly my $REPORTER =>
      Test::Approvals::Reporters::TortoiseDiffReporter->new();
    verify "Verify Hello World", $REPORTER, sub {
        return "Hello World";
    };

    verify "Verify Hello World", $REPORTER, sub {
        return "Hello World";
    };
}

test "Approve file doesn't exist.", sub {
    my ($namer) = @_;
    my $reporter = Test::Approvals::Reporter->new();
    verify_files( "File_that_does_not_exist", "a.txt", $reporter );
    ok( $reporter->was_called(), $namer->test_name() );
};

test "Test Files Match.", sub {
    my ($namer) = @_;
    my $reporter = Test::Approvals::Reporter->new();
    verify_files( "t/a1.txt", "t/a.txt", $reporter );
    ok( !$reporter->was_called(), $namer->test_name() );
};

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
