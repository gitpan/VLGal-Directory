use strict;

my $pkg_base = 'VLGal';
my $pkg = "${pkg_base}::Directory";
my $pkg_file = "${pkg_base}::File";
my $pkg_size = "${pkg_base}::Size";

push(@::bean_desc, {
    bean_opt => {
        abstract => 'Vincenzo\'s little gallery direcrory',
        package => $pkg,
        base => [ $pkg_file ],
        description => <<EOF,
C<$pkg> describes properties of Vincenzo's little gallery directories.
EOF
        short_description => 'Vincenzo\'s little gallery direcrory',
        synopsis => <<EOF
TODO
EOF
    },
    attr_opt => [
        {
            method_factory_name => '_all_file_',
            documented => 0,
            allow_ref => [ 'ARRAY' ],
        },
        {
            method_factory_name => 'file',
            type => 'MULTI',
            unique => 1,
            associative => 1,
            method_key => 1,
            id_method => 'get_basename',
            short_description => 'the list of files in the directory',
            allow_isa => [ $pkg_file ],
        },
    ],
    constr_opt => [
        {
            method_name => 'new_from_fs',
            parameter_description => 'OPT_HASH_REF',
            description => <<EOF,
Creates a new C<${pkg}> object from the specified C<dirname> and C<basename> options in C<OPT_HASH_REF>. C<OPT_HASH_REF> is a hash reference used to pass initialization options for C<${pkg_file}> objects. On error an exception C<Error::Simple> is thrown.
EOF
            body => <<'EOF',
    my $class = shift;
    my $opt = defined($_[0]) ? shift : {};

    # Check if file system name is a valid directory name
    my $fs_name = File::Spec->catfile( $opt->{dirname}, $opt->{basename} );
    ( -d $fs_name ) ||
        throw Error::Simple("ERROR: VLGal::Directory::new_from_fs, specified file system file name '$fs_name' is not a directory.");

    # Create a VLGal::Directory object and add files to it
    my $self = VLGal::Directory->new($opt);

    # Open directory and use factory to create files
    my %opt = %{$opt};
    my $dir = DirHandle->new( $fs_name );
    while ( my $basename = $dir->read() ) {
        # Skip this, super and '.vlgal' directory
        ( $basename eq '.' ) && next;
        ( $basename eq '..' ) && next;
        ( lc( $basename ) eq '.vlgal' ) && next;

        # Make new file
        $opt{dirname} = $fs_name;
        $opt{basename} = $basename;
        my $fs_name = File::Spec->catfile( $opt{dirname}, $opt{basename} );
        my $file = undef;
        if ( -d $fs_name ) {
            $file = VLGal::Directory->new_from_fs( \%opt );
        }
        elsif ( -f $fs_name ) {
            # Use the factory to create VLGal::File objects.
            $file = VLGal::File::Factory->instance()->create_file( \%opt );
        }

        # Add file to directory
        defined($file) && $self->add_file($file);
    }

    # Return $self
    return($self);
EOF
        },
    ],
    meth_opt => [
        {
            method_name => '_mk_vlgal_dir',
            documented => 0,
            body => <<'EOF',
    my $self = shift;

    # Get the style object
    my $style = VLGal::Style->instance();

    # Make the style basenames
    $style->_mk_size_basename();

    # Make the .vlgal directory
    ( -d $self->mk_vlgal_dir_name() ) ||
        mkdir( $self->mk_vlgal_dir_name() );

    # Make the .vlgal/icon directory
    my $icon_dir = File::Spec->catfile( $self->mk_vlgal_dir_name(), 'icon' );
    ( -d $icon_dir ) ||
        mkdir( $icon_dir );

    # Make the .vlgal/orig directory
    my $orig_dir = File::Spec->catfile( $self->mk_vlgal_dir_name(), 'orig' );
    ( -d $orig_dir ) ||
        mkdir( $orig_dir );

    # Copy the image_icon_folder to the .vlgal/icon directory
    my $img_folder = File::Spec->catfile(
        $icon_dir, basename( $style->get_image_icon_folder() )
    );
    ( -f $img_folder ) ||
        copy( $style->get_image_icon_folder(), $img_folder );

    # Copy the image_icon_next_peer to the .vlgal/icon directory
    my $img_next_peer = File::Spec->catfile(
        $icon_dir, basename( $style->get_image_icon_next_peer() )
    );
    ( -f $img_next_peer ) ||
        copy( $style->get_image_icon_next_peer(), $img_next_peer );

    # Copy the image_icon_next_seq to the .vlgal/icon directory
    my $img_next_seq = File::Spec->catfile(
        $icon_dir, basename( $style->get_image_icon_next_seq() )
    );
    ( -f $img_next_seq ) ||
        copy( $style->get_image_icon_next_seq(), $img_next_seq );

    # Copy the image_icon_previous_peer to the .vlgal/icon directory
    my $img_prev_peer = File::Spec->catfile(
        $icon_dir, basename( $style->get_image_icon_previous_peer() )
    );
    ( -f $img_prev_peer ) ||
        copy( $style->get_image_icon_previous_peer(), $img_prev_peer );

    # Copy the image_icon_previous_seq to the .vlgal/icon directory
    my $img_prev_seq = File::Spec->catfile(
        $icon_dir, basename( $style->get_image_icon_previous_seq() )
    );
    ( -f $img_prev_seq ) ||
        copy( $style->get_image_icon_previous_seq(), $img_prev_seq );

    # Make the size sub-directories
    foreach my $size ( $style->get_size() ) {
        my $size_sub = File::Spec->catfile(
            $self->mk_vlgal_dir_name(),
            $size->get_basename(),
        );
        ( -d $size_sub ) ||
            mkdir( $size_sub );
    }
EOF
        },
        {
            method_name => 'generate',
            body => <<'THE_EOF',
    my $self = shift;

    # Make the _all_file_ list
    $self->get_super_dir() ||
        $self->mk__all_file_();

    # Make code easier to read with $style
    my $style = VLGal::Style->instance();

    # Make the .vlgal directory
    $self->_mk_vlgal_dir();

    # Make dirname for index-vlgal.html file
    my $idx_dir = $self->mk_fs_name();

    # Make list of lists containing:
    # 1) Full index-vlgal.html name
    # 2)
    my $size_0 = ( $style->get_size() )[0];
    my $size_1 = ( $style->get_size() )[1];
    my @idx = ( [
        File::Spec->catfile(
            $self->mk_fs_name(),
            'index-vlgal.html'
        ),
        '.vlgal/icon',
        '.vlgal/' . $size_0->get_basename(),
        '..',
        '.vlgal/' . $size_1->get_basename() . '/__BASENAME__',
        '__BASENAME__/index-vlgal.html',
        '',
        '.vlgal',
        $size_1
    ] );
    my $i = -1;
    foreach my $size ( $style->get_size() ) {
        # Increment $i
        $i++;

        # Skip the thumbnail (0) and the default (1) size
        $i < 1 &&
            next;

        # Make the absolute index-vlgal.html file name
        my $idx_fn = File::Spec->catfile(
            $self->mk_fs_name(),
            '.vlgal',
            $size->get_basename(),
            'index-vlgal.html'
        );

        # Make the gp icon html directory
        my $gp_icon_html_dir = '../icon';

        # Make the img icon html directory
        my $img_icon_html_dir = '../' . $size_0->get_basename();

        # Make the super html directory
        my $super_html_dir = '../../../.vlgal/' . $size->get_basename();

        # Make the image html directory
        my $img_href_tmpl = '__BASENAME__';

        # Make the sub-directory html directory template
        my $sub_href_tmpl = '../../__BASENAME__/.vlgal/' .
                                $size->get_basename() . '/index-vlgal.html';

        # Make the default size-switch html directory prefix
        my $size_switch_def_html_dir = '../..';

        # Make the size-switch html directory prefix
        my $size_switch_html_dir = '..';

        # Push an entry on @idx
        push( @idx, [
            $idx_fn,
            $gp_icon_html_dir,
            $img_icon_html_dir,
            $super_html_dir,
            $img_href_tmpl,
            $sub_href_tmpl,
            $size_switch_def_html_dir,
            $size_switch_html_dir,
            $size
        ] );
    }

    # Make @dir and @file array
    my @dir = ();
    my @file = ();
    foreach my $key ( sort( $self->keys_file() ) ) {
        my $file = ( $self->values_file( $key ) )[0];
        if ( $file->isa('VLGal::Directory') ) {
            push( @dir, $file );
        }
        else {
            push( @file, $file );
        }
    }

    # Generate the html indexes
    foreach my $idx (@idx) {
        $self->generate_index_html( @{$idx}, \@dir, \@file );
    }

    # Generate all sub-dirs
    foreach my $dir (@dir) {
        $dir->generate();
    }

    # Generate all files
    for ( my $i = 0; $i < scalar(@file); $i++ ) {
        my $file = $file[$i];
        my $prev = undef;
        my $next = undef;
        $prev = $file[$i - 1] if ($i);
        $next = $file[$i + 1] if ($i < ( scalar(@file) - 1) );
        $file->generate( $prev, $next );
    }
THE_EOF
        },
        {
            method_name => 'generate_index_html',
            documented => 0,
            body => <<'THE_EOF',
    my $self = shift;
    my $fn = shift;
    my $gp_icon_html_dir = shift;
    my $img_icon_html_dir = shift;
    my $super_html_dir = shift;
    my $img_href_tmpl = shift;
    my $sub_href_tmpl = shift;
    my $size_switch_def_html_dir = shift;
    my $size_switch_html_dir = shift;
    my $size = shift;
    my $dir = shift;
    my $file = shift;

    # Make code easier to read with $style
    my $style = VLGal::Style->instance();

    # Print verbose message
    $style->is_verbose() &&
        print STDERR "Making file '$fn'.\n";

    # Open the index-vlgal.html file
    my $fh = IO::File->new( $fn, 'w' );
    defined($fh) ||
        throw Error::Simple("ERROR: VLGal::Directory::generate_index_html, failed to open file '$fn' for writing.");

    # Write the first part of the html header
    my $basename = $self->get_basename();
    $fh->print(<<EOF);
<html>
<!-- Generated through Vincenzo Zocca's VLGal Perl modules version $VERSION /-->
  <head>
      <style>
EOF

    # Write the css part of the html header
    my $css_fh = IO::File->new( $style->get_css_definition_file() );
    while (my $line = $css_fh->getline() ) {
        $fh->print($line);
    }

    # Write the remaining part of the html header
    $fh->print(<<EOF);
      </style>
      <title>Gallery of $basename</title>
  </head>
  <body>
EOF

    # Write super directory access line
    my @super = ();
    my $runner = $self;
    while ( my $super = $runner->get_super_dir() ) {
        push( @super, $super );
        $runner = $super;
    }
        $fh->print(<<EOF);
    <b>Path:</b>
EOF
    for ( my $i = scalar( @super ) - 1; $i >= 0; $i-- ) {
        my $super_base = $super[$i]->get_basename();
        my $super_dir = '../' x $i;
        $fh->print(<<EOF);
    <a href="${super_dir}${super_html_dir}/index-vlgal.html">$super_base</a> /
EOF
    }
    $fh->print(<<EOF);
    $basename
EOF

    # Generate table directories
    $self->generate_table(
        $fh,
        'Directories',
        $style->get_table_order_dir(),
        'directory',
        $style->get_max_columns_dir(),
        $gp_icon_html_dir,
        $sub_href_tmpl,
        $dir
    );

    # Generate table directories
    my $size_0 = ( $style->get_size() )[0];
    my $size_1 = ( $style->get_size() )[1];
    $self->generate_table(
        $fh,
        'Files',
        $style->get_table_order_image(),
        'file',
        $style->get_max_columns_image(),
        $img_icon_html_dir,
        $img_href_tmpl,
        $file
    );

    # Close html file
    $fh->print(<<EOF);
  </body>
</html>
EOF

    # Generate sizes
    $self->generate_size(
        $fh,
        $size,
        $size_switch_def_html_dir,
        $size_switch_html_dir
    );
THE_EOF
        },
        {
            method_name => 'generate_table',
            documented => 0,
            body => <<'THE_EOF',
    my $self = shift;
    my $fh = shift;
    my $title = shift;
    my $order = shift;
    my $class = shift;
    my $max_col = shift;
    my $icon_dir = shift;
    my $sub_href_tmpl = shift;
    my $file = shift;

    # Do nothing if no files
    scalar( @{$file} ) ||
        return();

    # Start table and make table header
    $fh->print(<<EOF);
    <hr class="$class">
    <table class="$class">
      <thead class="$class">
        <tr>
          <th colspan="$max_col">
            $title
          </th>
        </tr>
      </thead>
EOF

    # Start table row
    $fh->print(<<EOF);
      <tr class="$class">
EOF

    # Calculate the amount of rows
    my $rows = int( scalar( @{$file} ) / $max_col );
    $rows++ if ( scalar( @{$file} ) % $max_col );

    # Generate each row
    for ( my $i = 0; $i < $rows; $i++ ) {

        # Generate each column
        for ( my $j = 0; $j < $max_col; $j++ ) {

            # The number of the file
            my $file_nr;
            if ( $order eq 'z' ) {
                $file_nr += $i * $max_col + $j;
            }
            else {
                $file_nr += $i + $j * $rows;
            }

            # Get the file
            my $file = $file->[$file_nr];

            # Generate table data
            $file &&
                $file->generate_table_td($fh, $icon_dir, $sub_href_tmpl);
        }

        # New table row
        $i < scalar( @{$file} ) - 1 &&
            $fh->print(<<EOF);
      </tr>
      <tr class="$class">
EOF
    }

    # Finish table row
    $fh->print(<<EOF);
      </tr>
EOF

    # Finish table
    $fh->print(<<EOF);
    </table>
EOF
THE_EOF
        },
        {
            method_name => 'generate_table_td',
            documented => 0,
            body => <<'THE_EOF',
    my $self = shift;
    my $fh = shift;
    my $icon_dir = shift;
    my $sub_href_tmpl = shift;

    # Start table data
    $fh->print(<<EOF);
        <td class="directory">
EOF

    # Start anchor
    my $basename = $self->get_basename();
    $sub_href_tmpl =~ s/__BASENAME__/$basename/g;
    $fh->print(<<EOF);
          <a href="$sub_href_tmpl">
EOF

    # Icon and text in anchor
    my $src = join( '/',
        $icon_dir,
        basename( VLGal::Style->instance()->get_image_icon_folder() )
    );
    $fh->print(<<EOF);
            <img class="directory" src="$src">
            $basename
EOF

    # Print basename

    # End anchor
    $fh->print(<<EOF);
          </a>
EOF

    # End table data
    $fh->print(<<EOF);
        </td>
EOF
THE_EOF
        },
        {
            method_name => 'generate_size',
            documented => 0,
            body => <<'THE_EOF',
    my $self = shift;
    my $fh = shift;
    my $skip_size = shift;
    my $size_switch_def_html_dir = shift;
    my $size_switch_html_dir = shift;

    $fh->print(<<EOF);
          <hr>
          <b>Size:</b>
EOF
    my $i = -1;
    my $size_nr = scalar( VLGal::Style->instance()->get_size() );
    foreach my $size ( VLGal::Style->instance()->get_size() ) {
        $i++;
        $i > 0 ||
            next;

        my $label = $size->get_label();
        my $size_base = $size->get_basename();
        my $html_dir;
        if ( $i == 1 ) {
            $html_dir = $size_switch_def_html_dir;
            $label = "(default) $label";
        }
        else {
            $html_dir = "$size_switch_html_dir/$size_base";
        }

        my $slash;
        if ( $i == $size_nr - 1 ) {
            $slash = '';
        }
        else {
            $slash = ' /';
        }

        if ( $skip_size == $size ) {
            $fh->print(<<EOF);
          $label${slash}
EOF
        }
        else {
            $fh->print(<<EOF);
          <a href="$html_dir/index-vlgal.html"> $label </a>${slash}
EOF
        }
    }
THE_EOF
        },
        {
            method_name => 'mk__all_file_',
            documented => 0,
            body => <<'EOF',
    my $self = shift;

    # Make a list of files
    my @file = ();
    foreach my $basename ( sort( $self->keys_file() ) ) {
        my $file = ( $self->values_file( $basename ) )[0];
        push(@file, $file);
        $file->isa('VLGal::Directory') ||
            next;
        $file->mk__all_file_();
        my $sub_file = $file->get__all_file_();
        push( @file, @{ $sub_file->[0] } );
    }

    # Make an index of the list
    my %file = ();
    for ( my $i = 0; $i < scalar(@file); $i++ ) {
        $file{ $file[$i] } = $i;
    }

    # Store the list and the index
    $self->set__all_file_( [
        \@file, \%file
    ] );
EOF
        },
        {
            method_name => 'mk_vlgal_dir_name',
            body => <<'EOF',
    my $self = shift;

    return( File::Spec->catfile( $self->get_dirname(), $self->get_basename(), '.vlgal' ) );
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
            dependency_name => 'File::Basename',
        },
        {
            dependency_name => 'File::Copy',
        },
        {
            dependency_name => 'IO::File',
        },
        {
            dependency_name => 'VLGal::File::Factory',
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

