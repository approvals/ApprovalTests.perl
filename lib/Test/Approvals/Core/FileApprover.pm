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
        return verify_parts( $writer, $namer, $reporter );
    }

    sub verify_parts {
        my ( $writer, $namer, $reporter ) = @_;
        my $received =
          $writer->write_to(
            $namer->get_received_file( $writer->file_extension() ) );
        my $approved = $namer->get_approved_file( $writer->file_extension() );
        return verify_files( $approved, $received, $reporter );
    }

    sub verify_files {
        my ( $approved_file, $received_file, $reporter ) = @_;

        my $reporter_delegate =
          _get_reporter_delegate( $approved_file, $received_file, $reporter );

        my $approval_exists = _get_comparer(
            'Approved file does not exist:',
            sub { ( -e $approved_file ) },
            $reporter_delegate
        );

        my $same_sizes = _get_comparer(
            'File sizes do not match:',
            sub { ( -s $approved_file ) == ( -s $received_file ) },
            $reporter_delegate
        );

        my $same_content = _get_comparer(
            'Files do not match:',
            sub { compare( $approved_file, $received_file ) == 0 },
            $reporter_delegate
        );

        my $ok = $approval_exists->() && $same_sizes->() && $same_content->();
        if ($ok) {
            unlink $received_file;
        }
        return $ok;
    }

    sub report {
        my ( $message, $approved_file, $received_file, $reporter ) = @_;
        $TEST->diag(
            "\n$message\nAPPROVED: $approved_file\nRECEIVED: $received_file\n");
        $reporter->report( $approved_file, $received_file );
        return;
    }

    sub _get_comparer {
        my ( $message, $predicate, $reporter_delegate ) = @_;
        return sub {
            my $ok = $predicate->();
            if ( !$ok ) {
                $reporter_delegate->($message);
            }
            return $ok;
          }
    }

    sub _get_reporter_delegate {
        my ( $approved_file, $received_file, $reporter ) = @_;
        return sub {
            my ($message) = @_;
            report( $message, $approved_file, $received_file, $reporter );
          }
    }
}
1;
__END__
=head1 NAME

Test::Approvals::Core::FileApprover - Verify two files are the same
