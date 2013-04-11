#!perl
use strict;
use warnings FATAL => 'all';

package Test::Approvals::Core::FileApprover;
{
    use version; our $VERSION = qv(0.0.1);

    use File::Compare;
    use Test::Builder;
    use Readonly;

    require Exporter;
    use base qw(Exporter);

    our @EXPORT_OK = qw(verify verify_files verify_parts);

    Readonly my $TEST => Test::Builder->new();

    sub verify {
        my ( $writer, $namer, $reporter ) = @_;

        my $ext = $writer->file_extension;

        my $approved = $namer->get_approved_file($ext);
        my $received = $namer->get_received_file($ext);

        $writer->write_to($received);

        my $e = verify_files( $received, $approved );
        my $ok = !defined $e;
        if ( !$ok ) {
            my $message = "\n$e:\nAPPROVED: $approved\nRECEIVED: $received\n";
            $TEST->diag($message);
            $reporter->report( $received, $approved );
        }
        else {
            unlink $received;
        }

        return $ok;
    }

    sub verify_files {
        my ( $received_file, $approved_file ) = @_;

        if ( !-e $approved_file ) {
            return 'Approved file does not exist';
        }

        if ( ( -s $approved_file ) != ( -s $received_file ) ) {
            return 'File sizes do not match';
        }

        if ( compare( $approved_file, $received_file ) != 0 ) {
            return 'Files do not match';
        }

        return;
    }
}
1;
__END__
=head1 NAME

Test::Approvals::Core::FileApprover - Verify two files are the same

=head1 SUBROUTINES

=head2 verify

    my $w = Test::Approvals::Writers::TextWriter->new( result => 'Hello' );
    my $r = Test::Approvals::Reporters::FakeReporter->new();
    my $n = Test::Approvals::Namers::DefaultNamer->new( name => 'Hello Test' );

    ok verify( $w, $n, $r ), $n->name;

Low level method to verify that the result data matches the approved data 
(stored in a file).  Returns a value indicating whether the data matches and
invokes the reporter when needed.

=head2 verify_files

    my $failure = verify_files('r.txt', 'a.txt');
    if(defined $failure) {
        print "Verification failed because: $failure";
    }
    else {
        pring "Verification success!";
    }

Compare two files and return a message if they are not the same.  When they
are the same, return null.
