package VLGal::Style;

use 5.006;
use strict;
use warnings;
use Error qw(:try);
use VLGal::Size;

# Singleton variable
our $SINGLETON = undef;

# Used by _value_is_allowed
our %ALLOW_ISA = (
    'size' => [ 'VLGal::Size' ],
);

# Used by _value_is_allowed
our %ALLOW_REF = (
);

# Used by _value_is_allowed
our %ALLOW_RX = (
);

# Used by _value_is_allowed
our %ALLOW_VALUE = (
    'table_order_dir' => {
        'n' => 1,
        'z' => 1,
    },
    'table_order_image' => {
        'n' => 1,
        'z' => 1,
    },
);

# Used by _initialize
our %DEFAULT_VALUE = (
    #'css_definition_file' => 'VLGal/lib/default.css file @INC',
    #'image_icon_folder' => 'VLGal/lib/icon-folder.png file @INC',
    #'image_icon_next_peer' => 'VLGal/lib/icon-next-peer.png file @INC',
    #'image_icon_next_seq' => 'VLGal/lib/icon-next-seq.png file @INC',
    #'image_icon_previous_peer' => 'VLGal/lib/icon-previous-peer.png file @INC',
    #'image_icon_previous_seq' => 'VLGal/lib/icon-previous-seq.png file @INC',
    'max_columns_dir' => 8,
    'max_columns_image' => 5,
    'size' => [
        VLGal::Size->new( {
            max_height => 90,
            max_width => 90,
        } ),
        VLGal::Size->new( {
            max_height => 600,
            max_width => 600,
        } ),
        VLGal::Size->new( {
            max_height => 800,
            max_width => 800,
        } ),
        VLGal::Size->new( {
            max_height => 1000,
            max_width => 1000,
        } ),
        VLGal::Size->new( {
            max_height => 0,
            max_width => 0,
        } ),
    ],
    'table_order_dir' => 'n',
    'table_order_image' => 'z',
);

# Library files
our %LIB_FILE = (
    css_definition_file => 'default.css',
    image_icon_folder => 'icon-folder.png',
    image_icon_next_peer => 'icon-next-peer.png',
    image_icon_next_seq => 'icon-next-seq.png',
    image_icon_previous_peer => 'icon-previous-peer.png',
    image_icon_previous_seq => 'icon-previous-seq.png',
);

# Package version
our ($VERSION) = '$Revision: 0.01 $' =~ /\$Revision:\s+([^\s]+)/;

=head1 NAME

VLGal::Style - contains VLGal code style information

=head1 SYNOPSIS

 TODO

=head1 ABSTRACT

Vincenzo's little gallery style

=head1 DESCRIPTION

C<VLGal::Style> class to style Vincenzo's little gallery.

=head1 CONSTRUCTOR

=over

=item new( [ OPT_HASH_REF ] )

Creates a new C<VLGal::Style> object. C<OPT_HASH_REF> is a hash reference used to pass initialization options. On error an exception C<Error::Simple> is thrown.

Options for C<OPT_HASH_REF> may include:

=over

=item B<C<css_definition_file>>

Passed to L<set_css_definition_file()>. Defaults to the B<VLGal/lib/default.css> file in C<@INC>.

=item B<C<image_icon_folder>>

Passed to L<set_image_icon_folder()>. Defaults to the B<VLGal/lib/icon-folder.png> file in C<@INC>.

=item B<C<image_icon_next_peer>>

Passed to L<set_image_icon_next_peer()>. Defaults to the B<VLGal/lib/icon-next-peer.png> file in C<@INC>.

=item B<C<image_icon_next_seq>>

Passed to L<set_image_icon_next_seq()>. Defaults to the B<VLGal/lib/icon-next-seq.png> file in C<@INC>.

=item B<C<image_icon_previous_peer>>

Passed to L<set_image_icon_previous_peer()>. Defaults to the B<VLGal/lib/icon-previous-peer.png> file in C<@INC>.

=item B<C<image_icon_previous_seq>>

Passed to L<set_image_icon_previous_seq()>. Defaults to the B<VLGal/lib/icon-previous-seq.png> file in C<@INC>.

=item B<C<max_columns_dir>>

Passed to L<set_max_columns_dir()>. Defaults to B<8>.

=item B<C<max_columns_image>>

Passed to L<set_max_columns_image()>. Defaults to B<5>.

=item B<C<size>>

Passed to L<set_size()>. Must be an C<ARRAY> reference. Defaults to:

 [
     VLGal::Size->new( {
         max_height => 90,
         max_width => 90,
     } ),
     VLGal::Size->new( {
         max_height => 600,
         max_width => 600,
     } ),
     VLGal::Size->new( {
         max_height => 800,
         max_width => 800,
     } ),
     VLGal::Size->new( {
         max_height => 1000,
         max_width => 1000,
     } ),
     VLGal::Size->new( {
         max_height => 0,
         max_width => 0,
     } ),
 ],

=item B<C<table_order_dir>>

Passed to L<set_table_order_dir()>. Defaults to B<'n'>.

=item B<C<table_order_image>>

Passed to L<set_table_order_image()>. Defaults to B<'z'>.

=item B<C<verbose>>

Passed to L<set_verbose()>.

=back

=back

=head1 METHODS

=over

=item exists_size(ARRAY)

Returns the count of items in C<ARRAY> that are in the list of size description objects for the file.

=item get_css_definition_file()

Returns the B<css> definition file to use.

=item get_image_icon_folder()

Returns the icon image to use to view a child page in the gallery.

=item get_image_icon_next_peer()

Returns the icon image to use to view the next peer in the gallery.

=item get_image_icon_next_seq()

Returns the icon image to use to view the next item in sequence in the gallery.

=item get_image_icon_previous_peer()

Returns the icon image to use to view the previous peer in the gallery.

=item get_image_icon_previous_seq()

Returns the icon image to use to view the previous item in sequence in the gallery.

=item get_max_columns_dir()

Returns the maximal amount of columns in the directory table.

=item get_max_columns_image()

Returns the maximal amount of columns in the image table.

=item get_size( [ INDEX_ARRAY ] )

Returns an C<ARRAY> containing the list of size description objects for the file. C<INDEX_ARRAY> is an optional list of indexes which when specified causes only the indexed elements in the ordered list to be returned. If not specified, all elements are returned.

=item get_table_order_dir()

Returns the table ordering for directories.

=item get_table_order_image()

Returns the table ordering for images.

=item instance( [ CONSTR_OPT ] )

Always returns the same C<VLGal::Style> -singleton- object instance. The first time it is called, parameters C<CONSTR_OPT> -if specified- are passed to the constructor.

=item is_verbose()

Returns whether to print messages to C<STDERR> during C<html> code generation and image scaling or not.

=item pop_size()

Pop and return an element off the list of size description objects for the file. On error an exception C<Error::Simple> is thrown.

=item push_size(ARRAY)

Push additional values on the list of size description objects for the file. C<ARRAY> is the list value. On error an exception C<Error::Simple> is thrown.

=over

=item The values in C<ARRAY> must be a (sub)class of:

=over

=item VLGal::Size

=back

=back

=item set_css_definition_file(VALUE)

Set the B<css> definition file to use. C<VALUE> is the value. Default value at initialization is the B<VLGal/lib/default.css> file in C<@INC>. On error an exception C<Error::Simple> is thrown.

=item set_idx_size( INDEX, VALUE )

Set value in the list of size description objects for the file. C<INDEX> is the integer index which is greater than or equal to C<0>. C<VALUE> is the value.

=over

=item The values in C<ARRAY> must be a (sub)class of:

=over

=item VLGal::Size

=back

=back

=item set_image_icon_folder(VALUE)

Set the icon image to use to view a child page in the gallery. C<VALUE> is the value. Default value at initialization is the B<VLGal/lib/icon-folder.png> file in C<@INC>. On error an exception C<Error::Simple> is thrown.

=item set_image_icon_next_peer(VALUE)

Set the icon image to use to view the next peer in the gallery. C<VALUE> is the value. Default value at initialization is the B<VLGal/lib/icon-next-peer.png> file in C<@INC>. On error an exception C<Error::Simple> is thrown.

=item set_image_icon_next_seq(VALUE)

Set the icon image to use to view the next item in sequence in the gallery. C<VALUE> is the value. Default value at initialization is the B<VLGal/lib/icon-next-seq.png> file in C<@INC>. On error an exception C<Error::Simple> is thrown.

=item set_image_icon_previous_peer(VALUE)

Set the icon image to use to view the previous peer in the gallery. C<VALUE> is the value. Default value at initialization is the B<VLGal/lib/icon-previous-peer.png> file in C<@INC>. On error an exception C<Error::Simple> is thrown.

=item set_image_icon_previous_seq(VALUE)

Set the icon image to use to view the previous item in sequence in the gallery. C<VALUE> is the value. Default value at initialization is the B<VLGal/lib/icon-previous-seq.png> file in C<@INC>. On error an exception C<Error::Simple> is thrown.

=item set_max_columns_dir(VALUE)

Set the maximal amount of columns in the directory table. C<VALUE> is the value. Default value at initialization is C<8>. On error an exception C<Error::Simple> is thrown.

=item set_max_columns_image(VALUE)

Set the maximal amount of columns in the image table. C<VALUE> is the value. Default value at initialization is C<5>. On error an exception C<Error::Simple> is thrown.

=item set_num_size( NUMBER, VALUE )

Set value in the list of size description objects for the file. C<NUMBER> is the integer index which is greater than C<0>. C<VALUE> is the value.

=over

=item The values in C<ARRAY> must be a (sub)class of:

=over

=item VLGal::Size

=back

=back

=item set_size(ARRAY)

Set the list of size description objects for the file absolutely. C<ARRAY> is the list value. Default value at initialization is:

 [
     VLGal::Size->new( {
         max_height => 90,
         max_width => 90,
     } ),
     VLGal::Size->new( {
         max_height => 600,
         max_width => 600,
     } ),
     VLGal::Size->new( {
         max_height => 800,
         max_width => 800,
     } ),
     VLGal::Size->new( {
         max_height => 1000,
         max_width => 1000,
     } ),
     VLGal::Size->new( {
         max_height => 0,
         max_width => 0,
     } ),
 ],

On error an exception C<Error::Simple> is thrown.

=over

=item The values in C<ARRAY> must be a (sub)class of:

=over

=item VLGal::Size

=back

=back

=item set_table_order_dir(VALUE)

Set the table ordering for directories. C<VALUE> is the value. Default value at initialization is C<n>. On error an exception C<Error::Simple> is thrown.

=over

=item VALUE must be a one of:

=over

=item n

=item z

=back

=back

=item set_table_order_image(VALUE)

Set the table ordering for images. C<VALUE> is the value. Default value at initialization is C<z>. On error an exception C<Error::Simple> is thrown.

=over

=item VALUE must be a one of:

=over

=item n

=item z

=back

=back

=item set_verbose(VALUE)

State that to print messages to C<STDERR> during C<html> code generation and image scaling. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=item shift_size()

Shift and return an element off the list of size description objects for the file. On error an exception C<Error::Simple> is thrown.

=item unshift_size(ARRAY)

Unshift additional values on the list of size description objects for the file. C<ARRAY> is the list value. On error an exception C<Error::Simple> is thrown.

=over

=item The values in C<ARRAY> must be a (sub)class of:

=over

=item VLGal::Size

=back

=back

=back

=head1 SEE ALSO

L<VLGal::Directory>,
L<VLGal::File>,
L<VLGal::File::Factory>,
L<VLGal::File::MMagic>,
L<VLGal::Size>

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
    ref($opt) eq 'HASH' || throw Error::Simple("ERROR: VLGal::Style::_initialize, first argument must be 'HASH' reference.");

    # Check lib files
    &_check_lib_files($opt);

    # css_definition_file, SINGLE, with default value
    $self->set_css_definition_file( exists( $opt->{css_definition_file} ) ? $opt->{css_definition_file} : $DEFAULT_VALUE{css_definition_file} );

    # image_icon_folder, SINGLE, with default value
    $self->set_image_icon_folder( exists( $opt->{image_icon_folder} ) ? $opt->{image_icon_folder} : $DEFAULT_VALUE{image_icon_folder} );

    # image_icon_next_peer, SINGLE, with default value
    $self->set_image_icon_next_peer( exists( $opt->{image_icon_next_peer} ) ? $opt->{image_icon_next_peer} : $DEFAULT_VALUE{image_icon_next_peer} );

    # image_icon_next_seq, SINGLE, with default value
    $self->set_image_icon_next_seq( exists( $opt->{image_icon_next_seq} ) ? $opt->{image_icon_next_seq} : $DEFAULT_VALUE{image_icon_next_seq} );

    # image_icon_previous_peer, SINGLE, with default value
    $self->set_image_icon_previous_peer( exists( $opt->{image_icon_previous_peer} ) ? $opt->{image_icon_previous_peer} : $DEFAULT_VALUE{image_icon_previous_peer} );

    # image_icon_previous_seq, SINGLE, with default value
    $self->set_image_icon_previous_seq( exists( $opt->{image_icon_previous_seq} ) ? $opt->{image_icon_previous_seq} : $DEFAULT_VALUE{image_icon_previous_seq} );

    # max_columns_dir, SINGLE, with default value
    $self->set_max_columns_dir( exists( $opt->{max_columns_dir} ) ? $opt->{max_columns_dir} : $DEFAULT_VALUE{max_columns_dir} );

    # max_columns_image, SINGLE, with default value
    $self->set_max_columns_image( exists( $opt->{max_columns_image} ) ? $opt->{max_columns_image} : $DEFAULT_VALUE{max_columns_image} );

    # size, MULTI, with default value
    if ( exists( $opt->{size} ) ) {
        ref( $opt->{size} ) eq 'ARRAY' || throw Error::Simple("ERROR: VLGal::Style::_initialize, specified value for option 'size' must be an 'ARRAY' reference.");
        $self->set_size( @{ $opt->{size} } );
    }
    else {
        $self->set_size( @{ $DEFAULT_VALUE{size} } );
    }

    # table_order_dir, SINGLE, with default value
    $self->set_table_order_dir( exists( $opt->{table_order_dir} ) ? $opt->{table_order_dir} : $DEFAULT_VALUE{table_order_dir} );

    # table_order_image, SINGLE, with default value
    $self->set_table_order_image( exists( $opt->{table_order_image} ) ? $opt->{table_order_image} : $DEFAULT_VALUE{table_order_image} );

    # verbose, BOOLEAN
    exists( $opt->{verbose} ) && $self->set_verbose( $opt->{verbose} );

    # Return $self
    return($self);
}

sub _check_lib_files {
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
}

sub _mk_size_basename {
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

sub exists_size {
    my $self = shift;

    # Count occurrences
    my $count = 0;
    foreach my $val1 (@_) {
        foreach my $val2 ( @{ $self->{VLGal_Style}{size} } ) {
            ( $val1 eq $val2 ) && $count ++;
        }
    }
    return($count);
}

sub get_css_definition_file {
    my $self = shift;

    return( $self->{VLGal_Style}{css_definition_file} );
}

sub get_image_icon_folder {
    my $self = shift;

    return( $self->{VLGal_Style}{image_icon_folder} );
}

sub get_image_icon_next_peer {
    my $self = shift;

    return( $self->{VLGal_Style}{image_icon_next_peer} );
}

sub get_image_icon_next_seq {
    my $self = shift;

    return( $self->{VLGal_Style}{image_icon_next_seq} );
}

sub get_image_icon_previous_peer {
    my $self = shift;

    return( $self->{VLGal_Style}{image_icon_previous_peer} );
}

sub get_image_icon_previous_seq {
    my $self = shift;

    return( $self->{VLGal_Style}{image_icon_previous_seq} );
}

sub get_max_columns_dir {
    my $self = shift;

    return( $self->{VLGal_Style}{max_columns_dir} );
}

sub get_max_columns_image {
    my $self = shift;

    return( $self->{VLGal_Style}{max_columns_image} );
}

sub get_size {
    my $self = shift;

    if ( scalar(@_) ) {
        my @ret = ();
        foreach my $i (@_) {
            push( @ret, $self->{VLGal_Style}{size}[ int($i) ] );
        }
        return(@ret);
    }
    else {
        # Return the full list
        return( @{ $self->{VLGal_Style}{size} } );
    }
}

sub get_table_order_dir {
    my $self = shift;

    return( $self->{VLGal_Style}{table_order_dir} );
}

sub get_table_order_image {
    my $self = shift;

    return( $self->{VLGal_Style}{table_order_image} );
}

sub instance {
    # Allow calls like:
    # - VLGal::Style::instance()
    # - VLGal::Style->instance()
    # - $variable->instance()
    if ( ref($_[0]) && &UNIVERSAL::isa( $_[0], 'VLGal::Style' ) ) {
        shift;
    }
    elsif ( ! ref($_[0]) && $_[0] eq 'VLGal::Style' ) {
        shift;
    }

    # If $SINGLETON is defined return it
    defined($SINGLETON) && return($SINGLETON);

    # Create the object and set $SINGLETON
    $SINGLETON = VLGal::Style->new(@_);

    # Return $SINGLETON
    return($SINGLETON);
}

sub is_verbose {
    my $self = shift;

    if ( $self->{VLGal_Style}{verbose} ) {
        return(1);
    }
    else {
        return(0);
    }
}

sub pop_size {
    my $self = shift;

    # Pop an element from the list
    return( pop( @{ $self->{VLGal_Style}{size} } ) );
}

sub push_size {
    my $self = shift;

    # Check if isas/refs/rxs/values are allowed
    &_value_is_allowed( 'size', @_ ) || throw Error::Simple("ERROR: VLGal::Style::push_size, one or more specified value(s) '@_' is/are not allowed.");

    # Push the list
    push( @{ $self->{VLGal_Style}{size} }, @_ );
}

sub set_css_definition_file {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'css_definition_file', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_css_definition_file, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{css_definition_file} = $val;
}

sub set_idx_size {
    my $self = shift;
    my $idx = shift;
    my $val = shift;

    # Check if index is a positive integer or zero
    ( $idx == int($idx) ) || throw Error::Simple("ERROR: VLGal::Style::set_idx_size, the specified index '$idx' is not an integer.");
    ( $idx >= 0 ) || throw Error::Simple("ERROR: VLGal::Style::set_idx_size, the specified index '$idx' is not a positive integer or zero.");

    # Check if isas/refs/rxs/values are allowed
    &_value_is_allowed( 'size', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_idx_size, one or more specified value(s) '@_' is/are not allowed.");

    # Set the value in the list
    $self->{VLGal_Style}{size}[$idx] = $val;
}

sub set_image_icon_folder {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'image_icon_folder', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_image_icon_folder, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{image_icon_folder} = $val;
}

sub set_image_icon_next_peer {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'image_icon_next_peer', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_image_icon_next_peer, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{image_icon_next_peer} = $val;
}

sub set_image_icon_next_seq {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'image_icon_next_seq', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_image_icon_next_seq, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{image_icon_next_seq} = $val;
}

sub set_image_icon_previous_peer {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'image_icon_previous_peer', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_image_icon_previous_peer, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{image_icon_previous_peer} = $val;
}

sub set_image_icon_previous_seq {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'image_icon_previous_seq', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_image_icon_previous_seq, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{image_icon_previous_seq} = $val;
}

sub set_max_columns_dir {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'max_columns_dir', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_max_columns_dir, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{max_columns_dir} = $val;
}

sub set_max_columns_image {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'max_columns_image', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_max_columns_image, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{max_columns_image} = $val;
}

sub set_num_size {
    my $self = shift;
    my $num = shift;

    # Check if index is an integer
    ( $num == int($num) ) || throw Error::Simple("ERROR: VLGal::Style::set_num_size, the specified number '$num' is not an integer.");

    # Call set_idx_size
    $self->set_idx_size( $num - 1, @_ );
}

sub set_size {
    my $self = shift;

    # Check if isas/refs/rxs/values are allowed
    &_value_is_allowed( 'size', @_ ) || throw Error::Simple("ERROR: VLGal::Style::set_size, one or more specified value(s) '@_' is/are not allowed.");

    # Set the list
    @{ $self->{VLGal_Style}{size} } = @_;
}

sub set_table_order_dir {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'table_order_dir', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_table_order_dir, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{table_order_dir} = $val;
}

sub set_table_order_image {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'table_order_image', $val ) || throw Error::Simple("ERROR: VLGal::Style::set_table_order_image, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Style}{table_order_image} = $val;
}

sub set_verbose {
    my $self = shift;

    if (shift) {
        $self->{VLGal_Style}{verbose} = 1;
    }
    else {
        $self->{VLGal_Style}{verbose} = 0;
    }
}

sub shift_size {
    my $self = shift;

    # Shift an element from the list
    return( shift( @{ $self->{VLGal_Style}{size} } ) );
}

sub unshift_size {
    my $self = shift;

    # Check if isas/refs/rxs/values are allowed
    &_value_is_allowed( 'size', @_ ) || throw Error::Simple("ERROR: VLGal::Style::unshift_size, one or more specified value(s) '@_' is/are not allowed.");

    # Unshift the list
    unshift( @{ $self->{VLGal_Style}{size} }, @_ );
}

1;
