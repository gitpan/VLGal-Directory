package VLGal::Size;

use 5.006;
use strict;
use warnings;
use Error qw(:try);

# Used by _value_is_allowed
our %ALLOW_ISA = (
);

# Used by _value_is_allowed
our %ALLOW_REF = (
);

# Used by _value_is_allowed
our %ALLOW_RX = (
    'max_height' => [ '^\d*$' ],
    'max_width' => [ '^\d*$' ],
);

# Used by _value_is_allowed
our %ALLOW_VALUE = (
);

# Package version
our ($VERSION) = '$Revision: 0.01 $' =~ /\$Revision:\s+([^\s]+)/;

=head1 NAME

VLGal::Size - Size for Vincenzo's little gallery items

=head1 SYNOPSIS

TODO

=head1 ABSTRACT

Size for Vincenzo's little gallery items

=head1 DESCRIPTION

C<VLGal::Size> contains size attributes for gallery items.

=head1 CONSTRUCTOR

=over

=item new( [ OPT_HASH_REF ] )

Creates a new C<VLGal::Size> object. C<OPT_HASH_REF> is a hash reference used to pass initialization options. On error an exception C<Error::Simple> is thrown.

Options for C<OPT_HASH_REF> may include:

=over

=item B<C<basename>>

Passed to L<set_basename()>.

=item B<C<label>>

Passed to L<set_label()>.

=item B<C<max_height>>

Passed to L<set_max_height()>.

=item B<C<max_width>>

Passed to L<set_max_width()>.

=back

=back

=head1 METHODS

=over

=item get_basename()

Returns the basename of the directory containing item's from its size.

=item get_label()

Returns the label of the directory containing item's from its size.

=item get_max_height()

Returns the item's maximal height.

=item get_max_width()

Returns the item's maximal width.

=item set_basename(VALUE)

Set the basename of the directory containing item's from its size. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=item set_label(VALUE)

Set the label of the directory containing item's from its size. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=item set_max_height(VALUE)

Set the item's maximal height. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=over

=item VALUE must match regular expression:

=over

=item ^\d*$

=back

=back

=item set_max_width(VALUE)

Set the item's maximal width. C<VALUE> is the value. On error an exception C<Error::Simple> is thrown.

=over

=item VALUE must match regular expression:

=over

=item ^\d*$

=back

=back

=back

=head1 SEE ALSO

L<VLGal::Directory>,
L<VLGal::File>,
L<VLGal::File::Factory>,
L<VLGal::File::MMagic>,
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
    ref($opt) eq 'HASH' || throw Error::Simple("ERROR: VLGal::Size::_initialize, first argument must be 'HASH' reference.");

    # basename, SINGLE
    exists( $opt->{basename} ) && $self->set_basename( $opt->{basename} );

    # label, SINGLE
    exists( $opt->{label} ) && $self->set_label( $opt->{label} );

    # max_height, SINGLE
    exists( $opt->{max_height} ) && $self->set_max_height( $opt->{max_height} );

    # max_width, SINGLE
    exists( $opt->{max_width} ) && $self->set_max_width( $opt->{max_width} );

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

sub get_basename {
    my $self = shift;

    return( $self->{VLGal_Size}{basename} );
}

sub get_label {
    my $self = shift;

    return( $self->{VLGal_Size}{label} );
}

sub get_max_height {
    my $self = shift;

    return( $self->{VLGal_Size}{max_height} );
}

sub get_max_width {
    my $self = shift;

    return( $self->{VLGal_Size}{max_width} );
}

sub set_basename {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'basename', $val ) || throw Error::Simple("ERROR: VLGal::Size::set_basename, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Size}{basename} = $val;
}

sub set_label {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'label', $val ) || throw Error::Simple("ERROR: VLGal::Size::set_label, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Size}{label} = $val;
}

sub set_max_height {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'max_height', $val ) || throw Error::Simple("ERROR: VLGal::Size::set_max_height, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Size}{max_height} = $val;
}

sub set_max_width {
    my $self = shift;
    my $val = shift;

    # Check if isa/ref/rx/value is allowed
    &_value_is_allowed( 'max_width', $val ) || throw Error::Simple("ERROR: VLGal::Size::set_max_width, the specified value '$val' is not allowed.");

    # Assignment
    $self->{VLGal_Size}{max_width} = $val;
}

1;
