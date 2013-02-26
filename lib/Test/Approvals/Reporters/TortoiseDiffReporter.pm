
package Test::Approvals::Reporters::TortoiseDiffReporter;
{
    use Moose;
    use File::Touch;
    use Win32::Process;
    use FindBin::Real qw(Bin);

    with 'Test::Approvals::Reporters::Reporter';

    sub report {
        my ( $self, $approved, $received ) = @_;

        $approved =~ s{/}{\\\\}gmisx;
        $received =~ s{/}{\\\\}gmisx;

        my $bin = "C:\\Program Files\\TortoiseSVN\\bin\\";
        my $exe = "tortoisemerge.exe";
        touch($approved);

        my $process;
        Win32::Process::Create( $process, "$bin$exe",
            "\"$bin$exe\" \"$received\" \"$approved\"",
            0, DETACHED_PROCESS, Bin() );
    }
}
1;
__END__
=head1 NAME

Test::Approvals::Reporters::TortoiseDiffReporter - Report failures with 
TortoiseMerge

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