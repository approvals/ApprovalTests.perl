#! perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::FakeReporter;
{
    use version; our $VERSION = qv(0.0.1);
    use Moose;

    has 'was_called', isa => 'Bool', is => 'rw', default => 0;

    with 'Test::Approvals::Reporters::Reporter';

    sub report {
        my ( $self, $approved, $received ) = @_;
        $self->was_called(1);
        return;
    }
}
__PACKAGE__->meta->make_immutable;

1;
