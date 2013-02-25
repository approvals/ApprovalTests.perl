#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::MultiReporter;
{
    use version; our $VERSION = qv(0.0.1);

    use Moose::Role;

    has reporters => ( is => 'ro', isa => 'ArrayRef', default => sub { [] } );
    has exe       => ( is => 'rw', isa => 'Str',      default => q{} );
    has argv      => ( is => 'rw', isa => 'Str',      default => q{} );

}
1;
