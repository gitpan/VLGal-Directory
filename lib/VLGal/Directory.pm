package VLGal::Directory;

use 5.006;
use base qw( VLGal::File );
use strict;
use warnings;
use DirHandle;
use Error qw(:try);
use File::Basename;
use File::Copy;
use File::Spec;
use IO::File;
use VLGal::File::Factory;

# Used by _value_is_allowed
our %ALLOW_ISA = (
    'file' => [ 'VLGal::File' ],
);

# Used by _value_is_allowed
our %ALLOW_REF = (
    '_all_file_' => {
        'ARRAY' => 1,
    },
);

# Used by _value_is_allowed
our %ALLOW_RX = (
);

# Used by _value_is_allowed
our %ALLOW_VALUE = (
);

# Package version
our ($VERSION) = '$Revision: 0.01 $' =~ /\$Revision:\s+([^\s]+)/;

=head1 NAME

VLGal::Directory - Vincenzo's little gallery direcrory

=head1 SYNOPSIS

TODO

=head1 ABSTRACT

Vincenzo's little gallery direcrory

=head1 DESCRIPTION

C<VLGal::Directory> describes properties of Vincenzo's little gallery directories.

=head1 CONSTRUCTOR

=over

=item new( [ OPT_HASH_REF ] )

Creates a new C<VLGal::Directory> object. C<OPT_HASH_REF> is a hash reference used to pass initialization options. On error an exception C<Error::Simple> is thrown.

Options for C<OPT_HASH_REF> may include:

=over

=item B<C<file>>

Passed to L<set_file()>. Must be an C<ARRAY> reference.

=back

Options for C<OPT_HASH_REF> inherited through package B<C<VLGal::File>> may include:

=over

=item B<C<basename>>

Passed to L<set_basename()>.

=item B<C<dirname>>

Passed to L<set_dirname()>.

=item B<C<super_dir>>

Passed to L<set_super_dir()>.

=back

=item new_from_fs(OPT_HASH_REF)

Creates a new C<VLGal::Directory> object from the specified C<dirname> and C<basename> options in C<OPT_HASH_REF>. C<OPT_HASH_REF> is a hash reference used to pass initialization options for C<VLGal::File> objects. On error an exception C<Error::Simple> is thrown.

=back

=head1 METHODS

=over

=item add_file( [ VALUE ... ] )

Add additional values on the list of files in the directory. Each C<VALUE> is an object out of which the id is obtained through method C<get_basename()>. The obtained B<key> is used to store the value and may be used for deletion and to fetch the value. 0 or more values may be supplied. Multiple occurrences of the same key yield in the last occurring key to be inserted and the rest to be ignored. Each key of the specified values is allowed to occur only once. On error an exception C<Error::Simple> is thrown.

=over

=item The values in C<ARRAY> must be a (sub)class of:

=over

=item VLGal::File

=back

=back

=item delete_file(ARRAY)

Delete elements from the list of files in the directory. Returns the number of deleted elements. On error an exception C<Error::Simple> is thrown.

=item exists_file(ARRAY)

Returns the count of items in C<ARRAY> that are in the list of files in the directory.

=item generate()

This method is an implementation from package C<VLGal::File>. Generates the C<HTML> files and image files that implement the gallery.

The file organisation leaves the original organisation as intact as possible. That is, in each directory one file C<index-vlgal.html> and one directory C<.vlgal> are claimed. The file C<index-vlgal.html> is the entry point for the gallery. Directory C<.vlgal> contains generated images in lower resolution and quality and C<HTML> files required by the gallery.

=item get_basename()

This method is inherited from package C<VLGal::File>. Returns the file's base name.

=item get_dirname()

This method is inherited from package C<VLGal::File>. Returns the file's directory name.

=item get_super_dir()

This method is inherited from package C<VLGal::File>. Returns the super directory in the file system.

=item keys_file()

Returns an C<ARRAY> containing the keys of the list of files in the directory.

=item mk_fs_name()

This method is inherited from package C<VLGal::File>. Makes the file systemn name of the object usinf C<dirname> and C<basename>.

=item mk_vlgal_dir_name()

This method is overloaded from package C<VLGal::File>. Makes the name of the C<.vlgal> directory.

=item set_basename(VALUE)

This method is inherited from package C<VLGal::File>. Set the file's base name. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=item set_dirname(VALUE)

This method is inherited from package C<VLGal::File>. Set the file's directory name. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=item set_file( [ VALUE ... ] )

Set the list of files in the directory absolutely using values. Each C<VALUE> is an object out of which the id is obtained through method C<get_basename()>. The obtained B<key> is used to store the value and may be used for deletion and to fetch the value. 0 or more values may be supplied. Multiple occurrences of the same key yield in the last occurring key to be inserted and the rest to be ignored. Each key of the specified values is allowed to occur only once. On error an exception C<Error::Simple> is thrown.

=over

=item The values in C<ARRAY> must be a (sub)class of:

=over

=item VLGal::File

=back

=back

=item set_super_dir(VALUE)

This method is inherited from package C<VLGal::File>. Set the super directory in the file system. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=over

=item VALUE must be a (sub)class of:

=over

=item VLGal::Directory

=back

=back

=item values_file( [ KEY_ARRAY ] )

Returns an C<ARRAY> containing the values of the list of files in the directory. If C<KEY_ARRAY> contains one or more C<KEY>s the values related to the C<KEY>s are returned. If no C<KEY>s specified all values are returned.

=back

=head1 SEE ALSO

L<VLGal::File>,
L<VLGal::File::Factory>,
L<VLGal::File::MMagic>,
L<VLGal::Size>,
L<VLGal::Style>

=head1 BUGS

None known (yet.)

=head1 HISTORY

First development: September 2003
Last update: October 2003

=head1 AUTHOR

Vincenzo Zocca

=head1 COPYRIGHT

Copyright 2003 by Vincenzo Zocca

=head1 LICENSE

This file is part of the C<VLGal> module hierarchy for Perl by
Vincenzo Zocca.

The VLGal module hierarchy is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2 of
the License, or (at your option) any later version.

The VLGal module hierarchy is distributed in the hope that it will
be useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the VLGal module hierarchy; if not, write to
the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
Boston, MA 02111-1307 USA

=cut

sub new_from_fs {
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
}

sub _initialize {
    my $self = shift;
    my $opt = defined($_[0]) ? shift : {};

    # Check $opt
    ref($opt) eq 'HASH' || throw Error::Simple("ERROR: VLGal::Directory::_initialize, first argument must be 'HASH' reference.");

    # _all_file_, SINGLE
    exists( $opt->{_all_file_} ) && $self->set__all_file_( $opt->{_all_file_} );

    # file, MULTI
    if ( exists( $opt->{file} ) ) {
        ref( $opt->{file} ) eq 'ARRAY' || throw Error::Simple("ERROR: VLGal::Directory::_initialize, specified value for option 'file' must be an 'ARRAY' reference.");
        $self->set_file( @{ $opt->{file} } );
    }
    else {
        $self->set_file();
    }

    # Call the superclass' _initialize
    $self->SUPER::_initialize($opt);

    # Return $self
    return($self);
}

sub _mk_vlgal_dir {
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
}

sub _value_is_allowed {
    my $name = shift;

    # Value is allowed if no ALLOW clauses exist for the named attribute
    if ( ! exists( $ALLOW_ISA{$name} ) && ! exists( $ALLOW_REF{$name} ) && ! exists( $ALLOW_RX{$name} ) && ! exists( $ALLOW_VALUE{$name} ) ) {
        return(1);
    }

    # At this point, all values in @_ must to be allowed
    CHECK_VALUES:
    foreach my $val (@_) {
        # Check ALLOW_ISA
        if ( ref($val) && exists( $ALLOW_ISA{$name} ) ) {
            foreach my $class ( @{ $ALLOW_ISA{$name} } ) {
                &UNIVERSAL::isa( $val, $class ) && next CHECK_VALUES;
            }
        }

        # Check ALLOW_REF
        if ( ref($val) && exists( $ALLOW_REF{$name} ) ) {
            exists( $ALLOW_REF{$name}{ ref($val) } ) && next CHECK_VALUES;
        }

        # Check ALLOW_RX
        if ( defined($val) && ! ref($val) && exists( $ALLOW_RX{$name} ) ) {
            foreach my $rx ( @{ $ALLOW_RX{$name} } ) {
                $val =~ /$rx/ && next CHECK_VALUES;
            }
        }

        # Check ALLOW_VALUE
        if ( ! ref($val) && exists( $ALLOW_VALUE{$name} ) ) {
            exists( $ALLOW_VALUE{$name}{$val} ) && next CHECK_VALUES;
        }

        # We caught a not allowed value
        return(0);
    }

    # OK, all values are allowed
    return(1);
}

sub add_file {
    my $self = shift;

    # Check if isas/refs/rxs/values are allowed
    &_value_is_allowed( 'file', @_ ) || throw Error::Simple("ERROR: VLGal::Directory::add_file, one or more specified value(s) '@_' is/are not allowed.");

    # Add keys/values
    foreach my $val (@_) {
        $self->{VLGal_Directory}{file}{ $val->get_basename() } = $val;
        $val->set_super_dir( $self );
    }
}

sub delete_file {
    my $self = shift;

    # Delete values
    my $del = 0;
    foreach my $val (@_) {
        exists( $self->{VLGal_Directory}{file}{$val} ) || next;
        delete( $self->{VLGal_Directory}{file}{$val} );
        $del ++;
    }
    return($del);
}

sub exists_file {
    my $self = shift;

    # Count occurrences
    my $count = 0;
    foreach my $val (@_) {
        $count += exists( $self->{VLGal_Directory}{file}{$val} );
    }
    return($count);
}

sub generate {
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
}

sub generate_index_html {
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
}

sub generate_size {
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
}

sub generate_table {
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
}

sub generate_table_td {
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
}

sub get__all_file_ {
    my $self = shift;

    return( $self->{VLGal_Directory}{_all_file_} );
}

sub keys_file {
    my $self = shift;

    # Return all keys
    return( keys( %{ $self->{VLGal_Directory}{file} } ) );
}

sub mk__all_file_ {
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
}

sub mk_vlgal_dir_name {
    my $self = shift;

    return( File::Spec->catfile( $self->get_dirname(), $self->get_basename(), '.vlgal' ) );
}

sub set__all_file_ {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( '_all_file_', $val ) || throw Error::Simple("ERROR: VLGal::Directory::set__all_file_, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Directory}{_all_file_} = $val;
}

sub set_file {
    my $self = shift;

    # Check if isas/refs/rxs/values are allowed
    &_value_is_allowed( 'file', @_ ) || throw Error::Simple("ERROR: VLGal::Directory::set_file, one or more specified value(s) '@_' is/are not allowed.");

    # Empty list
    $self->{VLGal_Directory}{file} = {};

    # Add keys/values
    foreach my $val (@_) {
        $self->{VLGal_Directory}{file}{ $val->get_basename() } = $val;
        $val->set_super_dir( $self );
    }
}

sub values_file {
    my $self = shift;

    if ( scalar(@_) ) {
        my @ret = ();
        foreach my $key (@_) {
            exists( $self->{VLGal_Directory}{file}{$key} ) && push( @ret, $self->{VLGal_Directory}{file}{$key} );
        }
        return(@ret);
    }
    else {
        # Return all values
        return( values( %{ $self->{VLGal_Directory}{file} } ) );
    }
}

1;
