package Test::Approvals::Reporters::TestBuilderReporter;
{
    use Moose;
    use Readonly;
    use Test::More;
    use Test::Builder;

    with 'Test::Approvals::Reporters::Reporter';

	Readonly my $TEST => Test::Builder->new();

    sub report {
        my ( $self, $approved, $received ) = @_;
        $TEST->ok( undef, $self->test_name() );
    }
}
1;
__END__
=head1 NAME

Test::Approvals::Reporters::TestBuilderReporter - Report failures with 
TAP

=head2 report

    my $received = 'test.received.txt';
    my $approved = 'test.approved.txt';
    $reporter->report($received, $approved);

Simply use 'ok' to report a failed test.  