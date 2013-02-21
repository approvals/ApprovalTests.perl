
package Test::Approvals::Reporters::BeyondCompareReporter;
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

        my $bin = "C:\\Program Files (x86)\\Beyond Compare 3\\";
        my $exe      = "BCompare.exe";
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
1;