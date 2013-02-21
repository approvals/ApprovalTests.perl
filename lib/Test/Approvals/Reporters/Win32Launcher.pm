
package Test::Approvals::Reporters::Win32Launcher;
{
    use Moose::Role;

    use File::Touch;
    use FindBin::Real qw(Bin);
    use Win32::Process;

    requires qw(exe argv);

    sub launch {
        my ( $self, $received, $approved ) = @_;
        my $exe  = $self->exe();
        my $argv = $self->argv();

        $argv =~ s/RECEIVED/$received/misx;
        $argv =~ s/APPROVED/$approved/misx;

        my $process;
        Win32::Process::Create( $process, "$exe", "\"$exe\" $argv",
            0, DETACHED_PROCESS, Bin() );
        return;
    }

    sub report {
        my ( $self, $approved, $received ) = @_;

        $approved = File::Spec->canonpath($approved);
        $received = File::Spec->canonpath($received);
        touch($approved);

        $self->launch( $received, $approved );
        return;
    }

}

1;