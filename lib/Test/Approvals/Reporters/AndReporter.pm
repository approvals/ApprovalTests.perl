package Test::Approvals::Reporters::AndReporter;
{
    use Moose;

    has reporters => ( is => 'ro' );

    with 'Test::Approvals::Reporters::Reporter';

    sub report {
        my ( $self, $approved, $received ) = @_;
        foreach my $reporter ( @{ $self->reporters() } ) {
            $reporter->report( $approved, $received );
        }
    }
}
1;