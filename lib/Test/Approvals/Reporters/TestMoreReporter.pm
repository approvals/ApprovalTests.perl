package Test::Approvals::Reporters::TestMoreReporter;
{
    use Moose;
    use Test::More;

    with 'Test::Approvals::Reporters::Reporter';

    sub report {
        my ( $self, $approved, $received ) = @_;
        ok( undef, $self->test_name() );
    }
}
1;
