#! perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::FileLauncherReporter;
{
    use version; our $VERSION = qv('v0.0_1');
    use Moose;

    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return locate_exe( q{}, 'cmd.exe' );
    }

    sub argv {
        return '/C "RECEIVED"';
    }
}
__PACKAGE__->meta->make_immutable;
1;
__END__
=head1 NAME

Test::Approvals::Reporters::FileLauncherReporter - Use Windows file associations
to display the file.

=head2 argv

    my $argv = $reporter->argv();

Retrieve the argument template used to ask the shell to find an application 
to display the file.

=head2 exe

    my $exe = $reporter->exe();

Retrieve the path to the shell.
