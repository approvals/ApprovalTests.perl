#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::P4MergeReporter;
{
    use version; our $VERSION = qv(0.0.1);
    use Moose;

    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return locate_exe( 'Perforce', 'p4merge.exe' );
    }

    sub argv {
        return '"APPROVED" "RECEIVED" "APPROVED" "APPROVED"';
    }
}
__PACKAGE__->meta->make_immutable;

1;
