# -*- perl -*-

use strict;

my $script = <<'SCRIPT';
~startperl~ -w

use File::Basename;
use Getopt::Long;
use VLGal::Directory;
use VLGal::Style;
use File::Spec;
# Globals
my $basename=basename($0);

# Options
my %opt_par = (
     css_definition_file => '',
     image_icon_folder => '',
     image_icon_next_peer => '',
     image_icon_next_seq => '',
     image_icon_previous_peer => '',
     image_icon_previous_seq => '',
     max_columns_dir => '',
     max_columns_image => '',
     max_size_list => '',
     table_order_dir => '',
     table_order_image => '',
);
my %opt_plain = (
     h => '',
     verbose => '',
);

# Get options
my %opt_spec = ();
&fill_option_spec();
if ( ! GetOptions( %opt_spec ) ) {
    &usage;
    exit(1);
}
my %opt = ();
&fill_option();

# Print usage
if ( $opt{h} ) {
    &usage();
    exit(0);
}

# Instanciate the style with the options
VLGal::Style->instance( \%opt );

# Create VLGal::Size objects
if ( $opt{max_size_list} ) {
    # Make lists out of options
    my @max_size_list = split(/[\s,:;]+/, $opt{max_size_list} );

    # Check amount of items in the lists
    scalar( @max_size_list ) < 2 &&
        die 'The list --max_size_list must contain at least two sizes';

    # Create VLGal::Size objects
    require VLGal::Size;
    my @size = ();
    foreach my $max_size ( @max_size_list ) {
        my ( $max_width, $max_height ) = split( /[xX]/, $max_size, 2 );
        push( @size, VLGal::Size->new( {
            max_height => $max_height,
            max_width => $max_width,
        } ) );
    }

    # Set the sizes in the style
    VLGal::Style->instance()->set_size( @size );
}

# Create VLGal::Directory objects and generate code
foreach my $dir ( @ARGV ) {
    $dir = File::Spec->catfile( $dir );
    ( -d $dir ) ||
        die "'$dir' is not a directory.";

    my $basename = basename($dir);
    my $dirname = dirname($dir);
    my $dir_obj = VLGal::Directory->new_from_fs( {
        basename => $basename,
        dirname => $dirname,
    } );
    $dir_obj->generate();
}

# Exit OK
exit(0);

sub fill_option {
    foreach my $key ( keys( %opt_par ) ) {
        $opt_par{$key} ||
            next;
        $opt{$key} = $opt_par{$key};
    }
    foreach my $key ( keys( %opt_plain ) ) {
        $opt_plain{$key} ||
            next;
        $opt{$key} = $opt_plain{$key};
    }
}

sub fill_option_spec {
    foreach my $key ( keys( %opt_par ) ) {
        $opt_spec{ "$key=s" } = \$opt_par{$key};
    }
    foreach my $key ( keys( %opt_plain ) ) {
        $opt_spec{ "$key" } = \$opt_plain{$key};
    }
}

sub usage {
    print STDERR <<EOF;
Vincenzo's little html gallery of images
Usage: $basename \\
    [--h] [--css_definition_file <file>] [--image_icon_folder <file>] \\
    [--image_icon_next_peer <file>] [--image_icon_next_seq <file>] \\
    [--image_icon_previous_peer <file>] [--image_icon_previous_seq <file>] \\
    [--max_columns_dir <nr>] [--max_columns_image <nr>] \\
    [--max_height_list <nr-list>] [--max_width_list <nr-list>] \\
    [--table_order_dir <n|z>] [--table_order_image <n|z>] \\
    [--verbose] directory...

  NOTES:
     --h:                               Show this message
     --css_definition_file <file>:      Css file to be used in the html files
     --image_icon_folder <file>:        Image for folder icon
     --image_icon_next_peer <file>:     Image for next-peer icon
     --image_icon_next_seq <file>:      Image for next-in-sequence icon
     --image_icon_previous_peer <file>: Image for previous-peer icon
     --image_icon_previous_seq <file>:  Image for previous-in-sequence icon
     --max_columns_dir <nr>:            Maximum columns of directories
     --max_columns_image <nr>:          Maximum columns of images
     --max_size_list <nr-list>:         Maxumum image size list
     --table_order_dir <n|z>:           Ordering of directories ('n' or 'z')
     --table_order_image <n|z>:         Ordering of images ('n' or 'z')
     --verbose:                         Show verbose messages
     directory...:                      Direcory list
EOF
}

__END__

=head1 NAME

vlgal - Vincenzo's little gallery

=head1 SYNOPSIS

 vlgal [--h] [--css_definition_file <file>] [--image_icon_folder <file>]
    [--image_icon_next_peer <file>] [--image_icon_next_seq <file>]
    [--image_icon_previous_peer <file>] [--image_icon_previous_seq <file>]
    [--max_columns_dir <nr>] [--max_columns_image <nr>]
    [--max_height_list <nr-list>] [--max_width_list <nr-list>]
    [--table_order_dir <n|z>] [--table_order_image <n|z>]
    [--verbose] directory...

=head1 DESCRIPTION

C<vlgal> implements a foto gallery browser in C<HTML>. It generates C<HTML> code to browse images. It also scales images to make thumbails out of them and to support different screen sizes.

The C<vlgal> layout is designed to be simple. There are two views. The B<directory> view shows images and sub-directories. The B<image> view shows thumbnails and allows to I<jump> to the next and previous images.

Both the B<directory> view and the B<image> view allow to switch the size of the images on the fly. The B<image> view allows to jump between directories in order to avoid having to switch between directories during browsing.

The C<HTML> code and scaled images are put inside the same directory where the original images reside. In each directory B<one> file C<index-vlgal.html> is created and C<one> directory C<.vlgal>.

The style can be customized by providing a C<CSS> file.

Also, several options are provided to alter the ordering and the size of the tables in which the directories and images are put in the B<directory> view.

=head2 Options:

=over

=item --h

Print help.

=item --css_definition_file <file>

Css file to be used in the html files. The contents of this file is put between C<E<lt>styleE<gt>> and C<E<lt>/styleE<gt>> tags. A default is provided as file C<VLGal/lib/default.css> in C<@INC>.

=item --image_icon_folder <file>

Image for folder icon. This file is copied into the C<.vlgal/icon> directory and referred in the C<html> files. A default is provided as file C<VLGal/lib/icon-folder.png> in C<@INC>.

=item --image_icon_next_peer <file>

Image for next-peer icon. This file is copied into the C<.vlgal/icon> directory and referred in the C<html> files. A default is provided as file C<VLGal/lib/icon-next-peer.png> in C<@INC>.

=item --image_icon_next_seq <file>

Image for next-in-sequence icon. This file is copied into the C<.vlgal/icon> directory and referred in the C<html> files. A default is provided as file C<VLGal/lib/icon-next-seq.png> in C<@INC>.

=item --image_icon_previous_peer <file>

Image for previous-peer icon. This file is copied into the C<.vlgal/icon> directory and referred in the C<html> files. A default is provided as file C<VLGal/lib/icon-previous-peer.png> in C<@INC>.

=item --image_icon_previous_seq <file>

Image for previous-in-sequence icon. This file is copied into the C<.vlgal/icon> directory and referred in the C<html> files. A default is provided as file C<VLGal/lib/icon-previous-seq.png> in C<@INC>.

=item --max_columns_dir <nr>

Maximum columns of directories. Defaults to C<8>.

=item --max_columns_image <nr>

Maximum columns of images. Defaults to C<5>.

=item --max_size_list <nr-list>

Maxumum image size list. The first size is the thumbnail size. The second size is the size displayed by default. A size of C<0x0> means the original size. Defaults to C<90x90,600x600,800x800,1000x1000,1200x1200,0x0>.


=item --verbose

Show verbose messages.

=back

=head1 SEE ALSO

L<VLGal::Directory>,
L<VLGal::File>,
L<VLGal::File::Factory>,
L<VLGal::File::MMagic>,
L<VLGal::Size>,
L<VLGal::Style>

=head1 BUGS

None known (yet).

=head1 HISTORY

First development: October 2003

=head1 AUTHOR

Vincenzo Zocca E<lt>Vincenzo@Zocca.comE<gt>

=head1 COPYRIGHT

Copyright 2003, Vincenzo Zocca.

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

=head1 VERSION

$Revision: 0.01 $

=cut

SCRIPT

use Config;

my $file = __FILE__; $file =~ s/\.PL$//;

$script =~ s/\~(\w+)\~/$Config{$1}/eg;
if (!(open(FILE, ">$file"))  ||
    !(print FILE $script)  ||
    !(close(FILE))) {
    die "Error while writing $file: $!\n";
}
print "Extracted $file from ",__FILE__," with variable substitutions.\n";

