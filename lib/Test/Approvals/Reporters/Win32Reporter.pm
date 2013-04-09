
package Test::Approvals::Reporters::Win32Reporter;
{
    use Moose::Role;

    use File::Touch;
    use FindBin::Real qw(Bin);
    use Win32::Process;

    requires qw(exe argv);

    sub launch {
        my ( $self,  $received, $approved, ) = @_;
        my $exe  = $self->exe();
        my $argv = $self->argv();

        $argv =~ s/RECEIVED/$received/gmisx;
        $argv =~ s/APPROVED/$approved/gmisx;

        my $process;
        Win32::Process::Create( $process, "$exe", "\"$exe\" $argv",
            0, DETACHED_PROCESS, Bin() );
        return;
    }

    sub report {
        my ( $self,  $received, $approved, ) = @_;

        $approved = File::Spec->canonpath($approved);
        $received = File::Spec->canonpath($received);
        touch($approved);

        $self->launch( $received, $approved );
        return;
    }

    sub default_argv {
        return '"RECEIVED" "APPROVED"';
    }

    sub locate_exe {
        my ( $relative_path, $exe ) = @_;

        my $find_in_path = sub {
            my $location = `where $exe`;
            if ( defined $location ) {
                chomp $location;
                return $location;
            }
            return;
        };

        my $find_in_x86 = sub {
            my $location = File::Spec->catfile( 'C:/Program Files (x86)',
                $relative_path, $exe );
            if ( -e $location ) {
                return $location;
            }
            return;
        };

        my $default = sub {
            return File::Spec->catfile( 'C:/Program Files', $relative_path,
                $exe );
        };

        return $find_in_path->() || $find_in_x86->() || $default->();
    }
}

1;
__END__
=head1 NAME

Test::Approvals::Reporters::Win32Reporter - Generic base for creating reporters
that work on Windows.

=head2 default_argv

    my $argv = $reporter->default_argv();

Retrieve the shell arguments commonly used by diff utilities.

=head2 launch

    my $received = 'test.received.txt';
    my $approved = 'test.approved.txt';
    $reporter->launch($received, $approved);

Create a detached Windows process for the diff utility, passing the new process
the arguments required to compare the approved file with the received file.

=head2 locate_exe

    # Path within "Program Files"
    my $relative_path = 'DiffUtilMaker/SuperDiff';

    # Diff utility executable name
    my $exe = 'SuperDiffUtil.exe';

    my $exe_path = locate_exe($relative_path, $exe);

Search for $exe on the path, and in common locations.  If not found, hope that 
it's underneath the Windows "Program Files" directory.

=head2 report

    my $received = 'test.received.txt';
    my $approved = 'test.approved.txt';
    $reporter->report($received, $approved);

Normalize the paths to received and approved files, then try to launch the diff
utility.    
