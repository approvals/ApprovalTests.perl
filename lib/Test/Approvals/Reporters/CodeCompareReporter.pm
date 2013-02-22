#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::CodeCompareReporter;
{
    use version; our $VERSION = qv(0.0.1);

    use Moose;
    use File::Spec;

    with 'Test::Approvals::Reporters::Win32Launcher';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return File::Spec->catfile( 'C:/Program Files/Devart/Code Compare/',
            'CodeCompare.exe' );
    }

    sub argv {
        return '/ENVIRONMENT=standalone "RECEIVED" "APPROVED"';
    }

    sub is_working_in_this_environment {
        my ($self) = @_;
        return $self->default_is_working_in_this_environment();
    }
}
__PACKAGE__->meta->make_immutable;

1;
