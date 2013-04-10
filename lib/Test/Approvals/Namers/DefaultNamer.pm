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
        $test      =~ s{[.]$}{}mixs;

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
