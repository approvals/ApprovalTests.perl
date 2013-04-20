#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::MultiReporter;
{
    use version; our $VERSION = qv('v0.0_1');

    use Moose::Role;

    has reporters => ( is => 'ro', isa => 'ArrayRef', default => sub { [] } );
    has exe       => ( is => 'rw', isa => 'Str',      default => q{} );
    has argv      => ( is => 'rw', isa => 'Str',      default => q{} );

}
1;
__END__
=head1 NAME

Test::Approvals::Reporters::MultiReporter - Provides a role for aggregate 
reporters to extend.

=head2 argv

	$reporter->argv('"APPROVED" "RECEIVED"');
    my $argv = $reporter->argv();
    
Gets or sets the argument template used to invoke the reporter from the shell.  
The extending class can set this value for objects that expect it to be set.

=head2 exe

	$reporter->exe('SuperDiff.exe');
    my $exe = $reporter->exe();

Gets or sets the path to the reporter's executable.  The extending class can 
set this value for objects that expect it to be set.

=head2 reporters

	my $reporters_ref = $reporter->reporters();

Retrieve the collection of reporters configured for this aggregate.
