#! perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::FakeReporter;
{
    use version; our $VERSION = qv('v0.0_1');
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
__END__
=head1 NAME

Test::Approvals::Reporters::FakeReporter - Reporter which doesn't actually do 
anything, but you can check to see if it was called.

=head2 report 

    my $received = 'test.received.txt';
    my $approved = 'test.approved.txt';
    $reporter->report($received, $approved);

Sets a value indicating that report was called.

=head2 was_called

    my $ok = $reporter->was_called();
    ok($ok, 'reporter was called');

Gets a value indicating whether report was called.  Mostly used for mocking 
reporters in tests for Test::Approvals itself.
