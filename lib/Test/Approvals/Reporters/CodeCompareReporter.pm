#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::CodeCompareReporter;
{
    use version; our $VERSION = qv(0.0.1);
    use Moose;

    with 'Test::Approvals::Reporters::Win32Launcher';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return locate_exe( 'Devart/Code Compare/', 'CodeCompare.exe' );
    }

    sub argv {
        return '/ENVIRONMENT=standalone "RECEIVED" "APPROVED"';
    }
}
__PACKAGE__->meta->make_immutable;

1;
