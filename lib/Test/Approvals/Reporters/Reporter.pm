package Test::Approvals::Reporters::Reporter;
{
    use Moose::Role;

    has test_name => (is=>'rw', isa=>'Str', default=>q{});

    requires qw(report);
}
1;