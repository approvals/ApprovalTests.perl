
package Test::Approvals::Reporters::FileLauncherReporter;
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

        my $exe = `where cmd.exe`;
        chomp $exe;
        $exe =~ s{\\}{\\\\}gmisx;

        touch($approved);

        my $process;
        Win32::Process::Create( $process, "$exe", "\"$exe\" /C \"$received\"",
            0, DETACHED_PROCESS, Bin() );
    }
}
1;
