#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::WinMergeReporter;
{
    use version; our $VERSION = qv(0.0.1);
    use Moose;

    with 'Test::Approvals::Reporters::Win32Launcher';
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
