package VLGal::File::MMagic;

use 5.006;
use base qw( VLGal::File );
use strict;
use warnings;
use DirHandle;
use Error qw(:try);
use File::Spec;
use Image::Magick;

# Package version
our ($VERSION) = '$Revision: 0.01 $' =~ /\$Revision:\s+([^\s]+)/;

=head1 NAME

VLGal::File::MMagic - Vincenzo's little gallery MMagic file

=head1 SYNOPSIS

TODO

=head1 ABSTRACT

Vincenzo's little gallery MMagic file

=head1 DESCRIPTION

C<VLGal::File::MMagic> describes properties of Vincenzo's little gallery MMagic file.

=head1 CONSTRUCTOR

=over

=item new( [ OPT_HASH_REF ] )

Creates a new C<VLGal::File::MMagic> object. C<OPT_HASH_REF> is a hash reference used to pass initialization options. On error an exception C<Error::Simple> is thrown.

Options for C<OPT_HASH_REF> inherited through package B<C<VLGal::File>> may include:

=over

=item B<C<basename>>

Passed to L<set_basename()>.

=item B<C<dirname>>

Passed to L<set_dirname()>.

=item B<C<super_dir>>

Passed to L<set_super_dir()>.

=back

=back

=head1 METHODS

=over

=item generate()

This method is an implementation from package C<VLGal::File>. Generates the C<HTML> files and image files that implement the gallery.

The file organisation leaves the original organisation as intact as possible. That is, in each directory one file C<index-vlgal.html> and one directory C<.vlgal> are claimed. The file C<index-vlgal.html> is the entry point for the gallery. Directory C<.vlgal> contains generated images in lower resolution and quality and C<HTML> files required by the gallery.

=item get_basename()

This method is inherited from package C<VLGal::File>. Returns the file's base name.

=item get_dirname()

This method is inherited from package C<VLGal::File>. Returns the file's directory name.

=item get_super_dir()

This method is inherited from package C<VLGal::File>. Returns the super directory in the file system.

=item mk_fs_name()

This method is inherited from package C<VLGal::File>. Makes the file systemn name of the object usinf C<dirname> and C<basename>.

=item mk_vlgal_dir_name()

This method is inherited from package C<VLGal::File>. Makes the name of the C<.vlgal> directory.

=item set_basename(VALUE)

This method is inherited from package C<VLGal::File>. Set the file's base name. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=item set_dirname(VALUE)

This method is inherited from package C<VLGal::File>. Set the file's directory name. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=item set_super_dir(VALUE)

This method is inherited from package C<VLGal::File>. Set the super directory in the file system. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=over

=item VALUE must be a (sub)class of:

=over

=item VLGal::Directory

=back

=back

=back

=head1 SEE ALSO

L<VLGal::Directory>,
L<VLGal::File>,
L<VLGal::File::Factory>,
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

sub generate {
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
}

1;
