package VLGal::File::Factory;

use 5.006;
use strict;
use warnings;
use Error qw(:try);
use File::MMagic;
use File::Spec;

# MMagic class variable
our $MMAGIC = undef;

# Singleton variable
our $SINGLETON = undef;

# Package version
our ($VERSION) = '$Revision: 0.01 $' =~ /\$Revision:\s+([^\s]+)/;

=head1 NAME

VLGal::File::Factory - Vincenzo's little gallery file factory

=head1 SYNOPSIS

TODO

=head1 ABSTRACT

Vincenzo's little gallery file factory

=head1 DESCRIPTION

C<VLGal::File::Factory> is a factory class to create C<VLGal::File> objects.

=head1 CONSTRUCTOR

=over

=item new()

Creates a new C<VLGal::File::Factory> object.

=back

=head1 METHODS

=over

=item create_file(OPT_HASH_REF)

Creates a C<VLGal::File> object based on the type of the file -put together fith options C<dirname> and C<basename>. C<OPT_HASH_REF> is a hash reference used to pass initialization options for the C<VLGal::File> object. On error an exception C<Error::Simple> is thrown.

=item instance( [ CONSTR_OPT ] )

Always returns the same C<VLGal::File::Factory> -singleton- object instance. The first time it is called, parameters C<CONSTR_OPT> -if specified- are passed to the constructor.

=back

=head1 SEE ALSO

L<VLGal::Directory>,
L<VLGal::File>,
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
    ref($opt) eq 'HASH' || throw Error::Simple("ERROR: VLGal::File::Factory::_initialize, first argument must be 'HASH' reference.");

    # Return $self
    return($self);
}

sub create_file {
    my $self = shift;
    my $opt = defined($_[0]) ? shift : {};

    # Make file name and file type from options
    my $fs_name = File::Spec->catfile( $opt->{dirname}, $opt->{basename} );

    # Do directories first
    ( -d $fs_name ) && return( VLGal::Directory->new_from_fs($opt) );

    # Make $MMAGIC
    $MMAGIC = File::MMagic->new() if( !defined($MMAGIC) );

    # Switch for supported types
    my $mime_type = $MMAGIC->checktype_filename($fs_name);
    if ( $mime_type eq 'image/gif' ||
        $mime_type eq 'image/jpeg' ||
        $mime_type eq 'image/png'
            ) {
        require VLGal::File::MMagic;
        return( VLGal::File::MMagic->new($opt) );
    }

    # Return undef if nothing can be created
    return(undef);
}

sub instance {
    # Allow calls like:
    # - VLGal::File::Factory::instance()
    # - VLGal::File::Factory->instance()
    # - $variable->instance()
    if ( ref($_[0]) && &UNIVERSAL::isa( $_[0], 'VLGal::File::Factory' ) ) {
        shift;
    }
    elsif ( ! ref($_[0]) && $_[0] eq 'VLGal::File::Factory' ) {
        shift;
    }

    # If $SINGLETON is defined return it
    defined($SINGLETON) && return($SINGLETON);

    # Create the object and set $SINGLETON
    $SINGLETON = VLGal::File::Factory->new(@_);

    # Return $SINGLETON
    return($SINGLETON);
}

1;
