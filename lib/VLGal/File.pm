package VLGal::File;

use 5.006;
use strict;
use warnings;
use Error qw(:try);
use File::Basename;
use VLGal::Style;

# Used by _value_is_allowed
our %ALLOW_ISA = (
    'super_dir' => [ 'VLGal::Directory' ],
);

# Used by _value_is_allowed
our %ALLOW_REF = (
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

VLGal::File - Vincenzo's little gallery file

=head1 SYNOPSIS

None. This is an abstract class.

=head1 ABSTRACT

Vincenzo's little gallery file

=head1 DESCRIPTION

C<VLGal::File> is an abstract class that describes generic properties of Vincenzo's little gallery file.

=head1 CONSTRUCTOR

=over

=item new( [ OPT_HASH_REF ] )

Creates a new C<VLGal::File> object. C<OPT_HASH_REF> is a hash reference used to pass initialization options. On error an exception C<Error::Simple> is thrown.

Options for C<OPT_HASH_REF> may include:

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

=item get_basename()

Returns the file's base name.

=item get_dirname()

Returns the file's directory name.

=item get_super_dir()

Returns the super directory in the file system.

=item mk_fs_name()

Makes the file systemn name of the object usinf C<dirname> and C<basename>.

=item mk_vlgal_dir_name()

Makes the name of the C<.vlgal> directory.

=item set_basename(VALUE)

Set the file's base name. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=item set_dirname(VALUE)

Set the file's directory name. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=item set_super_dir(VALUE)

Set the super directory in the file system. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=over

=item VALUE must be a (sub)class of:

=over

=item VLGal::Directory

=back

=back

=back

=head1 SEE ALSO

L<VLGal::Directory>,
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

sub new {
    my $class = shift;

    my $self = {};
    bless( $self, ( ref($class) || $class ) );
    return( $self->_initialize(@_) );
}

sub _initialize {
    my $self = shift;
    my $opt = defined($_[0]) ? shift : {};

    # Check $opt
    ref($opt) eq 'HASH' || throw Error::Simple("ERROR: VLGal::File::_initialize, first argument must be 'HASH' reference.");

    # basename, SINGLE
    exists( $opt->{basename} ) && $self->set_basename( $opt->{basename} );

    # dirname, SINGLE
    exists( $opt->{dirname} ) && $self->set_dirname( $opt->{dirname} );

    # super_dir, SINGLE
    exists( $opt->{super_dir} ) && $self->set_super_dir( $opt->{super_dir} );

    # Return $self
    return($self);
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

sub diff_html_dir {
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
}

sub generate {
    throw Error::Simple("ERROR: VLGal::File::generate, call this method in a subclass that has implemented it.");
}

sub generate_html {
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
}

sub generate_size {
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
}

sub generate_table_td {
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
}

sub generate_td_cont_next {
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
}

sub generate_td_cont_prev {
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
}

sub get_basename {
    my $self = shift;

    return( $self->{VLGal_File}{basename} );
}

sub get_dirname {
    my $self = shift;

    return( $self->{VLGal_File}{dirname} );
}

sub get_next_in_hier {
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
}

sub get_previous_in_hier {
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
}

sub get_root_dir {
    my $self = shift;

    my $root = undef;
    $root = $self if ( $self->isa('VLGal::Directory') );
    my $super = $self;
    while ( $super = $super->get_super_dir() ) {
        $root = $super;
    }
    return($root);
}

sub get_super_dir {
    my $self = shift;

    return( $self->{VLGal_File}{super_dir} );
}

sub mk_fs_name {
    my $self = shift;

    return( File::Spec->catfile( $self->get_dirname(), $self->get_basename() ) );
}

sub mk_vlgal_dir_name {
    my $self = shift;

    return( File::Spec->catfile( $self->get_dirname(), '.vlgal' ) );
}

sub set_basename {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'basename', $val ) || throw Error::Simple("ERROR: VLGal::File::set_basename, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_File}{basename} = $val;
}

sub set_dirname {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'dirname', $val ) || throw Error::Simple("ERROR: VLGal::File::set_dirname, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_File}{dirname} = $val;
}

sub set_super_dir {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'super_dir', $val ) || throw Error::Simple("ERROR: VLGal::File::set_super_dir, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_File}{super_dir} = $val;
}

1;
