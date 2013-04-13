
package Test::Approvals::Reporters::TortoiseDiffReporter;
{
    use Moose;

    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return locate_exe( 'TortoiseSVN\bin', 'tortoisemerge.exe' );
    }

    sub argv {
        return default_argv();
    }
}
1;
__END__
=head1 NAME

Test::Approvals::Reporters::TortoiseDiffReporter - Report failures with 
TortoiseMerge

=head2 METHODS

=head2 argv

Returns the argument portion expected by the reporter when invoked from the 
command line.

=head2 exe

Returns the path to the reporter executable.
