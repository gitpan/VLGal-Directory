use strict;

my $pkg_base = 'VLGal';
my $pkg = "${pkg_base}::Size";

push(@::bean_desc, {
    bean_opt => {
        abstract => 'Size for Vincenzo\'s little gallery items',
        package => $pkg,
        description => <<EOF,
C<$pkg> contains size attributes for gallery items.
EOF
        short_description => 'Size for Vincenzo\'s little gallery items',
        synopsis => <<EOF
TODO
EOF
    },
    attr_opt => [
        {
            method_factory_name => 'basename',
            type => 'SINGLE',
            short_description => 'the basename of the directory containing item\'s from its size',
        },
        {
            method_factory_name => 'label',
            type => 'SINGLE',
            short_description => 'the label of the directory containing item\'s from its size',
        },
        {
            method_factory_name => 'max_width',
            type => 'SINGLE',
            allow_rx => [ qw(^\d*$) ],
            short_description => 'the item\'s maximal width',
        },
        {
            method_factory_name => 'max_height',
            type => 'SINGLE',
            allow_rx => [ qw(^\d*$) ],
            short_description => 'the item\'s maximal height',
        },
    ],
    meth_opt => [
    ],
    sym_opt => [
    ],
    use_opt => [
        #{
        #    dependency_name => 'PerlBean::Style',
        #    import_list => [ 'qw(:codegen)' ],
        #},
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

