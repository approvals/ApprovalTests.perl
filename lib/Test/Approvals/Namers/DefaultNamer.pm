#! perl
use strict;
use warnings FATAL => qw(all);

package Test::Approvals::Namers::DefaultNamer;
{
    use version; our $VERSION = qv(0.0.1);

    use Moose;
    use File::Spec;
    use FindBin::Real qw(Bin Script);

    has 'directory', is => 'ro', isa => 'Str', default => Bin();
    has 'name', is => 'ro', isa => 'Str';

    sub get_filename {
        my ( $self, $extension, $type ) = @_;
        my $file = Script();
        my $test = $self->name();
        my $dir  = $self->directory;
        $extension =~ s{^[.]}{}mixs;
        $test =~ s{[.]$}{}mixs;

        my $full_filename = "$file.$test.$type.$extension";
        $full_filename =~ s/\s/_/gmisx;
        $full_filename = lc $full_filename;
        return File::Spec->catfile( $dir, $full_filename );
    }

    sub get_approved_file {
        my ( $self, $extension ) = @_;
        return get_filename( $self, $extension, 'approved' );

    }

    sub get_received_file {
        my ( $self, $extension ) = @_;
        return get_filename( $self, $extension, 'received' );
    }
}

1;
__END__
=head1 NAME

Test::Approvals::Namers::DefaultNamer - Default algorithm for generating names

=head1 METHODS

=head2 get_approved_file

    my $n = Test::Approvals::Namers::DefaultNamer->new(
        directory => 'c:\tmp',
        name      => 'foo'
    );
    my $path = $n->get_approved_file('txt');

Generate the full path to the approved file.  In the example above $path will
be assigned: 'C:\tmp\<script>.foo.approved.txt', where <script> is the name of
the caller's script (similar to the output of FindBin::Real::Script)

=head2 get_received_file

    my $n = Test::Approvals::Namers::DefaultNamer->new(
        directory => 'c:\tmp',
        name      => 'foo'
    );
    my $path = $n->get_received_file('txt');

Generate the full path to the received file.  In the example above $path will
be assigned: 'C:\tmp\<script>.foo.received.txt', where <script> is the name of
the caller's script (similar to the output of FindBin::Real::Script)

=head2 get_filename

    my $n = Test::Approvals::Namers::DefaultNamer->new(
        directory => 'c:\tmp',
        name      => 'foo'
    );
    my $path = $n->get_filename('txt', 'bar');

Generate the full path to the requested file of the requested type.  In the 
example above $path will be assigned: 'C:\tmp\<script>.foo.bar.txt', where 
<script> is the name of the caller's script (similar to the output of 
FindBin::Real::Script)
