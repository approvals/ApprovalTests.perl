#! perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::Reporter;
{
    use version; our $VERSION = qv(0.0.1);
    use Moose::Role;

    has test_name => ( is => 'rw', isa => 'Str', default => q{} );

    requires qw(report);
}
1;
__END__
=head1 NAME

Test::Approvals::Reporters::Reporter - Defines a role for reporters to 
extend.
