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
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return File::Spec->catfile( 'C:/Program Files (x86)/Beyond Compare 3/',
            'BCompare.exe' );
    }

    sub argv {
        return '"RECEIVED" "APPROVED"';
    }

    sub is_working_in_this_environment {
        my ($self) = @_;
        return $self->default_is_working_in_this_environment();
    }
}
__PACKAGE__->meta->make_immutable;
1;
