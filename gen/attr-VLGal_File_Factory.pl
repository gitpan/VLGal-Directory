use strict;

my $pkg_base = 'VLGal';
my $pkg_file = "${pkg_base}::File";
my $pkg = "${pkg_file}::Factory";

push(@::bean_desc, {
    bean_opt => {
        abstract => 'Vincenzo\'s little gallery file factory',
        package => $pkg,
        singleton => 1,
        description => <<EOF,
C<$pkg> is a factory class to create C<$pkg_file> objects.
EOF
        short_description => 'Vincenzo\'s little gallery file factory',
        synopsis => <<EOF
TODO
EOF
    },
    attr_opt => [
    ],
    meth_opt => [
        {
            method_name => 'create_file',
            parameter_description => 'OPT_HASH_REF',
            description => <<EOF,
Creates a C<$pkg_file> object based on the type of the file -put together fith options C<dirname> and C<basename>. C<OPT_HASH_REF> is a hash reference used to pass initialization options for the C<$pkg_file> object. On error an exception C<Error::Simple> is thrown.
EOF
            body => <<'EOF',
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
EOF
        },
    ],
    sym_opt => [
        {
            symbol_name => '$MMAGIC',
            comment => <<'EOF',
# MMagic class variable
EOF
            assignment => <<'EOF',
undef;
EOF
        },
    ],
    use_opt => [
        {
            dependency_name => 'File::Spec',
        },
        {
            dependency_name => 'File::MMagic',
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

