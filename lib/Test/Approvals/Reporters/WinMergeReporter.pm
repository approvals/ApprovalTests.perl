#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::WinMergeReporter;
{
    use version; our $VERSION = qv(0.0.1);
    use Moose;

    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return locate_exe( 'WinMerge', 'WinMergeU.exe' );
    }

    sub argv {
        return default_argv();
    }
}
__PACKAGE__->meta->make_immutable;
1;
__END__
=head1 NAME

Test::Approvals::Reporters::WinMergeReporter - Report failure with WinMerge.

=head2 argv

    my $argv = $reporter->argv();

Retrieve the argument template used to invoke the reporter from the shell.

=head2 exe

    my $exe = $reporter->exe();

Retrieve the path to the reporter's executable.
