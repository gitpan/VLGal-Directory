use strict;

my $pkg_base = 'VLGal';
my $pkg_file = "${pkg_base}::File";
my $pkg = "${pkg_file}::MMagic";

push(@::bean_desc, {
    bean_opt => {
        abstract => 'Vincenzo\'s little gallery MMagic file',
        package => $pkg,
        base => [ $pkg_file ],
        description => <<EOF,
C<$pkg> describes properties of Vincenzo's little gallery MMagic file.
EOF
        short_description => 'Vincenzo\'s little gallery MMagic file',
        synopsis => <<EOF
TODO
EOF
    },
    attr_opt => [
    ],
    constr_opt => [
    ],
    meth_opt => [
        {
            method_name => 'generate',
            body => <<'EOF',
    my $self = shift;
    my $prev_file = shift;
    my $next_file = shift;

    # Make the .vlgal directory
    ( -d $self->mk_vlgal_dir_name() ) || mkdir( $self->mk_vlgal_dir_name() );

    # For each size, make a file in the .vlgal directory
    my $i = -1;
    foreach my $size ( VLGal::Style->instance()->get_size() ) {
        $i++;
        # Make size directory if necessary
        my $size_dir = File::Spec->catfile(
            $self->get_dirname(),
            '.vlgal',
            $size->get_basename()
        );
        ( -d $size_dir ) || mkdir($size_dir);

        # Make resised file name
        my $fs_name_size = File::Spec->catfile(
            $size_dir,
            $self->get_basename()
        );

        # Write the html file
        if ( $i ) {
             my $super_html_dir;
             if ( $i == 1 ) {
                 $super_html_dir = '../..';
             }
             else {
                 $super_html_dir = '../../.vlgal/' . $size->get_basename();
             }
             $self->generate_html(
                 "$fs_name_size.html",
                 $super_html_dir,
                 $prev_file,
                 $next_file,
                 $size,
             );
        }

        # Do nothing if max_height or max_width equals 0
        $size->get_max_height() && $size->get_max_width() ||
            next;

        # Do nothing if the original file is older than the scaled file
        if ( -f $fs_name_size ) {
            my $time_orig = ( stat( $self->mk_fs_name() ) )[9];
            my $time_scale = ( stat( $fs_name_size ) )[9];
            $time_orig < $time_scale && next;
        }

        # Read the image into ImageMagick
        my $m = Image::Magick->new();
        $m->Read( $self->mk_fs_name() );

        # Get width and height and calculate a shrink factor
        my $width = $m->Get('width');
        my $height = $m->Get('height');
        my $shrink_w = $size->get_max_width() / $width;
        my $shrink_h = $size->get_max_height() / $height;
        my $shrink = $shrink_w < $shrink_h ? $shrink_w : $shrink_h;
        my $width_new = int( $width * $shrink );
        my $height_new = int( $height * $shrink );

        # Print verbose message
        VLGal::Style->instance()->is_verbose() &&
            print STDERR "Scaling file '",
                $self->mk_fs_name(),
                "' to $width_new x $height_new\n";


        # Make new width and height
        $m->Scale(
            'width' => $width_new,
            'height' => $height_new
        );

        # Write the scaled file
        $m->Write($fs_name_size);
    }
EOF
        },
    ],
    sym_opt => [
    ],
    use_opt => [
        {
            dependency_name => 'DirHandle',
        },
        {
            dependency_name => 'File::Spec',
        },
        {
            dependency_name => 'Image::Magick',
        },
    ],
} );

sub get_syn {
    use IO::File;
    my $fh = IO::File->new('< syn-PerlBean.pl');
    $fh = IO::File->new('< gen/syn-PerlBean.pl') if (! defined($fh));
    my $syn = '';
    my $prev_line = $fh->getline ();
    while (my $line = $fh->getline ()) {
        $syn .= ' ' . $prev_line;
        $prev_line = $line;
    }
    return($syn);
}

1;

