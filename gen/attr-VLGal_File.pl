use strict;

my $pkg_base = 'VLGal';
my $pkg = "${pkg_base}::File";
my $pkg_dir = "${pkg_base}::Directory";
my $pkg_size = "${pkg_base}::Size";

push(@::bean_desc, {
    bean_opt => {
        abstract => 'Vincenzo\'s little gallery file',
        package => $pkg,
        description => <<EOF,
C<$pkg> is an abstract class that describes generic properties of Vincenzo's little gallery file.
EOF
        short_description => 'Vincenzo\'s little gallery file',
        synopsis => <<EOF
None. This is an abstract class.
EOF
    },
    attr_opt => [
        {
            method_factory_name => 'super_dir',
            type => 'SINGLE',
            short_description => 'the super directory in the file system',
            allow_isa => [ $pkg_dir ],
        },
        {
            method_factory_name => 'dirname',
            type => 'SINGLE',
            short_description => 'the file\'s directory name',
        },
        {
            method_factory_name => 'basename',
            type => 'SINGLE',
            short_description => 'the file\'s base name',
        },
    ],
    meth_opt => [
        {
            method_name => 'generate',
            interface => 1,
            documented => 0,
            description => <<EOF,
Generates the C<HTML> files and image files that implement the gallery.

The file organisation leaves the original organisation as intact as possible. That is, in each directory one file C<index-vlgal.html> and one directory C<.vlgal> are claimed. The file C<index-vlgal.html> is the entry point for the gallery. Directory C<.vlgal> contains generated images in lower resolution and quality and C<HTML> files required by the gallery.
EOF
        },
        {
            method_name => 'generate_html',
            documented => 0,
            body => <<'THE_EOF',
    my $self = shift;
    my $fn = shift;
    my $super_html_dir = shift;
    my $prev_file = shift;
    my $next_file = shift;
    my $size = shift;

    # Make code easier to read with $style
    my $style = VLGal::Style->instance();

    # Print verbose message
    $style->is_verbose() &&
        print STDERR "Making file '$fn'.\n";

    # Open the index-vlgal.html file
    my $fh = IO::File->new( $fn, 'w' );
    defined($fh) ||
        throw Error::Simple("ERROR: VLGal::File::generate_html, failed to open file '$fn' for writing.");

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
    <table>
      <tr>
        <td class="navigation_chain">
EOF

    $self->generate_td_cont_prev( $fh, $size );

    $fh->print(<<EOF);
        </td>
        <td class="navigation_chain">
EOF

    $self->generate_td_cont_next( $fh, $size );

    $fh->print(<<EOF);
        </td>
        <td class="navigation">
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
        </td>
EOF

    # Close navigation table
    $fh->print(<<EOF);
      </tr>
    </table>
    <hr>
EOF

    # Make the image
    my $img_dir = '';
    if ( ! $size->get_max_height() || ! $size->get_max_width()  ) {
        $img_dir = '../../';
    }
    $fh->print(<<EOF);
    <img class="browse" src="${img_dir}$basename">
    <hr>
EOF

    # Generate sizes
    $self->generate_size(
        $fh,
        $size,
    );

    # Close html file
    $fh->print(<<EOF);
  </body>
</html>
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

    $fh->print(<<EOF);
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
        my $basename = $self->get_basename();
        if ( $i == 1 ) {
            $label = "(default) $label";
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
    <a href="../$size_base/$basename.html"> $label </a>${slash}
EOF
        }
    }
THE_EOF
        },
        {
            method_name => 'generate_table_td',
            documented => 0,
            body => <<'THE_EOF',
    my $self = shift;
    my $fh = shift;
    my $icon_dir = shift;
    my $href_tmpl = shift;

    # Start table data
    $fh->print(<<EOF);
        <td class="file">
EOF

    # Start anchor
    my $basename = $self->get_basename();
    $href_tmpl =~ s/__BASENAME__/$basename/g;
    $fh->print(<<EOF);
          <a href="$href_tmpl.html">
EOF

    # Icon and text in anchor
    $fh->print(<<EOF);
            <img class="file" src="$icon_dir/$basename"><br>
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
            method_name => 'generate_td_cont_next',
            documented => 0,
            body => <<'THE_EOF',
    my $self = shift;
    my $fh = shift;
    my $size = shift;

    # Get next
    my $next_file = $self->get_next_in_hier();

    # Return if none
    $next_file ||
        return();

    # Make code easier to read with $style
    my $style = VLGal::Style->instance();

    # Make the next path
    my $href = $self->diff_html_dir( $next_file );
    my $icon;
    if ( $href ) {
        $href = '../../' . $href . '.vlgal/' . $size->get_basename() . '/' . $next_file->get_basename();
        $icon = '../icon/' . basename( $style->get_image_icon_next_seq() );
    }
    else {
        $href = $href . $next_file->get_basename();
        $icon = '../icon/' . basename( $style->get_image_icon_next_peer() );
    }
    $fh->print(<<EOF);
          <a href="$href.html">
            <img class="navigation" src="$icon">
          </a>
EOF
THE_EOF
        },
        {
            method_name => 'generate_td_cont_prev',
            documented => 0,
            body => <<'THE_EOF',
    my $self = shift;
    my $fh = shift;
    my $size = shift;

    # Get previous
    my $prev_file = $self->get_previous_in_hier();

    # Return if none
    $prev_file ||
        return();

    # Make code easier to read with $style
    my $style = VLGal::Style->instance();

    # Make the previous path
    my $href = $self->diff_html_dir( $prev_file );
    my $icon;
    if ( $href ) {
        $href = '../../' . $href . '.vlgal/' . $size->get_basename() . '/' . $prev_file->get_basename();
        $icon = '../icon/' . basename( $style->get_image_icon_previous_seq() );
    }
    else {
        $href = $href . $prev_file->get_basename();
        $icon = '../icon/' . basename( $style->get_image_icon_previous_peer() );
    }
    $fh->print(<<EOF);
          <a href="$href.html">
            <img class="navigation" src="$icon">
          </a>
EOF
THE_EOF
        },
        {
            method_name => 'get_next_in_hier',
            documented => 0,
            body => <<'EOF',
    my $self = shift;

    $self->get_super_dir() ||
        return(undef);

    my $seq_hier = $self->get_root_dir()->get__all_file_();
    my $i = $seq_hier->[1]{$self};

    for ( my $j = $i + 1; $j < scalar( @{ $seq_hier->[0] } ); $j++ ) {
        if ( $self->isa( 'VLGal::Directory' ) ) {
            $seq_hier->[0][$j]->isa( 'VLGal::Directory' ) &&
                return( $seq_hier->[0][$j] );
        }
        else {
            $seq_hier->[0][$j]->isa( 'VLGal::Directory' ) ||
                return( $seq_hier->[0][$j] );
        }
    }
EOF
        },
        {
            method_name => 'get_previous_in_hier',
            documented => 0,
            body => <<'EOF',
    my $self = shift;

    $self->get_super_dir() ||
        return(undef);

    my $seq_hier = $self->get_root_dir()->get__all_file_();
    my $i = $seq_hier->[1]{$self};

    for ( my $j = $i - 1; $j >= 0; $j-- ) {
        if ( $self->isa( 'VLGal::Directory' ) ) {
            $seq_hier->[0][$j]->isa( 'VLGal::Directory' ) &&
                return( $seq_hier->[0][$j] );
        }
        else {
            $seq_hier->[0][$j]->isa( 'VLGal::Directory' ) ||
                return( $seq_hier->[0][$j] );
        }
    }
EOF
        },
        {
            method_name => 'get_root_dir',
            documented => 0,
            body => <<'EOF',
    my $self = shift;

    my $root = undef;
    $root = $self if ( $self->isa('VLGal::Directory') );
    my $super = $self;
    while ( $super = $super->get_super_dir() ) {
        $root = $super;
    }
    return($root);
EOF
        },
        {
            method_name => 'diff_html_dir',
            documented => 0,
            body => <<'EOF',
    my $self = shift;
    my $to_file = shift;

    $to_file ||
        return('');

    my @from_dir = ();
    my $runner = $self;
    while (my $super_dir = $runner->get_super_dir() ) {
        unshift( @from_dir, $super_dir );
        $runner = $super_dir;
    }

    my @to_dir = ();
    $runner = $to_file;
    while (my $super_dir = $runner->get_super_dir() ) {
        unshift( @to_dir, $super_dir );
        $runner = $super_dir;
    }

    while (1) {
        scalar( @from_dir ) && scalar( @to_dir ) ||
            last;
        ( $from_dir[0] != $to_dir[0] ) &&
            last;
        shift( @from_dir );
        shift( @to_dir );
    }

    my $diff = '../' x scalar( @from_dir );
    foreach my $file ( @to_dir ) {
        $diff .= $file->get_basename() . '/';
    }
    return( $diff );
EOF
        },
        {
            method_name => 'mk_vlgal_dir_name',
            description => <<EOF,
Makes the name of the C<.vlgal> directory.
EOF
            body => <<'EOF',
    my $self = shift;

    return( File::Spec->catfile( $self->get_dirname(), '.vlgal' ) );
EOF
        },
        {
            method_name => 'mk_fs_name',
            description => <<EOF,
Makes the file systemn name of the object usinf C<dirname> and C<basename>.
EOF
            body => <<'EOF',
    my $self = shift;

    return( File::Spec->catfile( $self->get_dirname(), $self->get_basename() ) );
EOF
        },
    ],
    sym_opt => [
    ],
    use_opt => [
        {
            dependency_name => 'File::Basename',
        },
        {
            dependency_name => 'VLGal::Style',
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

