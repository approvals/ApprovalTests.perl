package Test::Approvals::Reporters::FakeReporter;
{
    use Moose;

    has 'was_called', isa => 'Int', is => 'rw', default => 0;

    with 'Test::Approvals::Reporters::Reporter';

    sub report {
        my ( $self, $approved, $received ) = @_;
        $self->was_called(1);
    }
}
