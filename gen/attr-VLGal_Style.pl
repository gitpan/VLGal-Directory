use strict;
my $pkg_base = 'VLGal';
my $pkg_size = "${pkg_base}::Size";
my $pkg = "${pkg_base}::Style";

push(@::bean_desc, {
    bean_opt => {
        abstract => 'Vincenzo\'s little gallery style',
        package => $pkg,
        singleton => 1,
        short_description => 'contains VLGal code style information',
        description => <<EOF,
C<VLGal::Style> class to style Vincenzo's little gallery.
EOF
    },
    attr_opt => [
        {
            method_factory_name => 'size',
            type => 'MULTI',
            ordered => 1,
            short_description => 'the list of size description objects for the file',
            allow_isa => [ $pkg_size ],
            default_value => [ "$pkg_size->new();"],
        },
        {
            method_factory_name => 'css_definition_file',
            default_value => "$pkg_base/lib/default.css file \@INC",
            short_description => 'the B<css> definition file to use',
        },
        {
            method_factory_name => 'image_icon_folder',
            default_value => "$pkg_base/lib/icon-folder.png file \@INC",
            short_description => 'the icon image to use to view a child page in the gallery',
        },
        {
            method_factory_name => 'image_icon_next_peer',
            default_value => "$pkg_base/lib/icon-next-peer.png file \@INC",
            short_description => 'the icon image to use to view the next peer in the gallery',
        },
        {
            method_factory_name => 'image_icon_next_seq',
            default_value => "$pkg_base/lib/icon-next-seq.png file \@INC",
            short_description => 'the icon image to use to view the next item in sequence in the gallery',
        },
        {
            method_factory_name => 'image_icon_previous_peer',
            default_value => "$pkg_base/lib/icon-previous-peer.png file \@INC",
            short_description => 'the icon image to use to view the previous peer in the gallery',
        },
        {
            method_factory_name => 'image_icon_previous_seq',
            default_value => "$pkg_base/lib/icon-previous-seq.png file \@INC",
            short_description => 'the icon image to use to view the previous item in sequence in the gallery',
        },
        {
            method_factory_name => 'max_columns_dir',
            default_value => 8,
            short_description => 'the maximal amount of columns in the directory table',
        },
        {
            method_factory_name => 'max_columns_image',
            default_value => 5,
            short_description => 'the maximal amount of columns in the image table',
        },
        {
            method_factory_name => 'table_order_dir',
            default_value => 'n',
            allow_value => [ qw(n z) ],
            short_description => 'the table ordering for directories',
        },
        {
            method_factory_name => 'table_order_image',
            default_value => 'z',
            allow_value => [ qw(n z) ],
            short_description => 'the table ordering for images',
        },
        {
            method_factory_name => 'verbose',
            type => 'BOOLEAN',
            short_description => 'to print messages to C<STDERR> during C<html> code generation and image scaling',
        },
    ],
    meth_opt => [
        {
            method_name => '_check_lib_files',
            documented => 0,
            body => <<'EOF',
    my $opt = shift;

    # Check lib files
    foreach my $attr ( keys(%LIB_FILE) ) {
        # Do nothing if attribute in options
        $opt->{$attr} &&
            next;

        # Make file name
        my $def_fn = File::Spec->catfile( 'VLGal', 'lib', $LIB_FILE{$attr} );
        foreach my $dir ( @INC ) {
            # Make file name
            my $fs_name = File::Spec->catfile( $dir, $def_fn );

            # Check if file exists
            ( -f $fs_name ) ||
                next;

            # Set option
            $opt->{$attr} = $fs_name;
            last;
        }

        # Check if we have a file
        $opt->{$attr} ||
            throw Error::Simple("ERROR: VLGal::Style::_check_lib_files, failed to find file '$def_fn' in \@INC '@INC'.");
    }
EOF
        },
        {
            method_name => '_mk_size_basename',
            documented => 0,
            body => <<'EOF',
    my $self = shift;

    # Make the precision
    my $p = length( scalar( $self->get_size() ) );

    # Make the size basenames
    my $i = 0;
    foreach my $size ( $self->get_size() ) {
        $i++;

        # Make basename and label
        if ( $size->get_max_height() && $size->get_max_width() ) {
            $size->set_basename( sprintf(
                "%0${p}d-%sx%s",
                $i,
                $size->get_max_width(),
                $size->get_max_width()
            ) );
            $size->set_label( sprintf(
                "%sx%s",
                $size->get_max_width(),
                $size->get_max_width()
            ) );
        }
        else {
            $size->set_basename('orig');
            $size->set_label('Original');
        }
    }
EOF
        },
    ],
    sym_opt => [
        {
            symbol_name => '%LIB_FILE',
            comment => <<'EOF',
# Library files
EOF
            assignment => <<'EOF',
(
    css_definition_file => 'default.css',
    image_icon_folder => 'icon-folder.png',
    image_icon_next_peer => 'icon-next-peer.png',
    image_icon_next_seq => 'icon-next-seq.png',
    image_icon_previous_peer => 'icon-previous-peer.png',
    image_icon_previous_seq => 'icon-previous-seq.png',
);
EOF
        },
    ],
    tag_opt => [
    ],
    use_opt => [
        {
            dependency_name => 'VLGal::Size',
        },
    ],
} );

1;
