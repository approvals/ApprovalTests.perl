package Test::Approvals::Reporters::EnvironmentAwareReporter;
{
    use Moose::Role;

    requires qw(is_working_in_this_environment);

    sub default_is_working_in_this_environment {
        my ($self) = @_;
        return ( -e $self->exe() );
    }

}
1;
