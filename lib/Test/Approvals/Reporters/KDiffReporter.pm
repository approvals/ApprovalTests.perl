#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::KDiffReporter;
{
    use version; our $VERSION = qv('v0.0_1');
    use Moose;

    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return locate_exe( 'KDiff3', 'kdiff3.exe' );
    }

    sub argv {
        return default_argv();
    }
}
__PACKAGE__->meta->make_immutable;

1;
__END__
=head1 NAME

Test::Approvals::Reporters::KDiffReporter - Report failure with KDiff.

=head2 argv

    my $argv = $reporter->argv();

Retrieve the argument template used to invoke the reporter from the shell.

=head2 exe

    my $exe = $reporter->exe();

Retrieve the path to the reporter's executable.
