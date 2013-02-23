
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