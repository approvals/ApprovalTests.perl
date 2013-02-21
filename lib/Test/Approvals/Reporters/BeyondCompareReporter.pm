#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::BeyondCompareReporter;
{
    use version; our $VERSION = qv(0.0.1);
    use Moose;
    use File::Spec;

    with 'Test::Approvals::Reporters::Win32Launcher';
    with 'Test::Approvals::Reporters::Reporter';

    sub exe {
        return File::Spec->catfile( 'C:/Program Files (x86)/Beyond Compare 3/',
            'BCompare.exe' );
    }

    sub argv {
        return '"RECEIVED" "APPROVED"';
    }
}

1;
