package Test::Approvals::Reporters::ClipboardReporter;

use strict;
use warnings FATAL => 'all';
use version; our $VERSION = qv('v0.0.5_3');

{
    use Clipboard;
    use English qw(-no_match_vars);
    use Moose;

    with 'Test::Approvals::Reporters::Reporter';

    sub get_command_line {
        my ( $received, $approved, $os ) = @_;
        $os //= $OSNAME;
        if ( $os eq 'MSWin32' ) {
            return qq{move /Y "$received" "$approved"};
        }
        return qq{mv $received $approved};
    }

    sub report {
        my ( $self, $received, $approved ) = @_;
        Clipboard->copy( get_command_line( $received, $approved ) );
        return;
    }
}
__PACKAGE__->meta->make_immutable;
1;
__END__
=head1 NAME

Test::Approvals::Reporters::ClipboardReporter - Report with the clipboard

=head1 VERSION

This documentation refers to Test::Approvals::Reporters::ClipboardReporter version v0.0.5_3

=head1 SYNOPSIS

    use Test::Approvals::Reporters;

    my $reporter = Test::Approvals::Reporters::ClipboardReporter->new();
    $reporter->report( 'r.txt', 'a.txt' );

=head1 DESCRIPTION

This module reports by pasting a move command onto the operating system
clipboard.  Paste into a terminal window and execute to move the received file
over to the approved file.

=head1 SUBROUTINES/METHODS

=head2 get_command_line

    my $cmd = get_command_line( 'r.txt', 'a.txt', 'darwin' );

Gets the os-appropriate move command.  Override the os using the optional
third parameter, or use only the first two parameters to atomatically detect
the current OS.

=head2 report

Copy the move command to the operating system clipboard.

=head1 DIAGNOSTICS

None at this time.

=head1 CONFIGURATION AND ENVIRONMENT

None

=head1 DEPENDENCIES

=over 4

Moose
Clipboard
version

=back

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

None known.

=head1 AUTHOR

Jim Counts - @jamesrcounts

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2013 Jim Counts

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    L<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

