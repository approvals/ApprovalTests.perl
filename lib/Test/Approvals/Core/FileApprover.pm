package Test::Approvals::Exception;
{
    use Exception::Class 'Test::Approvals::Failed';
}

package Test::Approvals::Core::FileApprover;

use Test::Builder;
require Exporter;

our @EXPORT = qw(verify_files verify_parts);
our @ISA    = qw(Exporter);

my $Test = Test::Builder->new();

sub verify_parts {
    my ( $writer, $namer, $reporter ) = @_;
    my $received =
      $writer->write( $namer->get_received_file( $writer->file_extension() ) );
    my $approved = $namer->get_approved_file( $writer->file_extension() );
    my $ok = verify_files( $approved, $received, $reporter );
    $Test->ok($ok, $namer->test_name());
}

sub verify_files {
    my ( $approved_file, $received_file, $reporter ) = @_;

    if ( !-e $approved_file ) {
        throw_reporter_error( "Approved file does not exist: $approved_file",
            $approved_file, $received_file, $reporter );
        return;
    }
    elsif ( ( -s $approved_file ) != ( -s $received_file ) ) {
        throw_reporter_error( "File sizes do not match.",
            $approved_file, $received_file, $reporter );
        return;
    }
    else {
        open my $approved_handle, '<', $approved_file;
        my $approved_byte = 1;
        open my $received_handle, '<', $received_file;
        my $received_byte = 1;

        my $offset = 0;

        while ( $approved_byte != 0 ) {
            if ( $approved_byte != $received_byte ) {
                close $approved_handle;
                close $received_handle;

                throw_reporter_error(
                    "Files do not match.", $approved_file,
                    $received_file,        $reporter
                );

                return;
            }

            read $received_handle, $received_byte, 1, $offset;
            my $offset += read $approved_handle, $approved_byte, 1, $offset;
        }
    }

    return 1;
}

sub throw_reporter_error {
    my ( $message, $approved_file, $received_file, $reporter ) = @_;
    print STDERR
      "$message:\n APPROVED: $approved_file\n RECEIVED: $received_file\n";
    $reporter->report( $approved_file, $received_file );

    #Test::Approvals::Failed->throw( error => $message );
    #ok(undef, $message);
}

1;
