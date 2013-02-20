package Test::Approvals::Namer;
{
    use Moose;
    use FindBin::Real qw(Bin Script);

    has 'test_name', is => 'rw', isa => 'Str';

    sub get_directory {
        return Bin() . '/';
    }

    sub get_filename {
        my ( $self, $extension, $type ) = @_;
        my $file = Script();
        my $test = $self->test_name();
        my $dir  = $self->get_directory();
        $extension =~ s{^[.]}{}mixs;

        my $full_filename = "$file.$test.$type.$extension";
        $full_filename =~ s/\s/_/gmisx;
        $full_filename = lc $full_filename;
        return "$dir$full_filename";
    }

    sub get_approved_file {
        my ( $self, $extension ) = @_;
        return get_filename( $self, $extension, "approved" );

    }

    sub get_received_file {
        my ( $self, $extension ) = @_;
        return get_filename( $self, $extension, "received" );
    }
}

1;
